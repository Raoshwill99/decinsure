;; Decentralized Insurance Mechanism for Smart Contract Failures
;; Phase 2: Claim and Payout System

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INSUFFICIENT_BALANCE (err u101))
(define-constant ERR_INVALID_CONTRACT (err u102))
(define-constant ERR_CLAIM_ALREADY_EXISTS (err u103))
(define-constant ERR_NO_CLAIM_EXISTS (err u104))

;; Data Variables
(define-data-var insurance-pool uint u0)

;; Maps
(define-map contributors principal uint)
(define-map insured-contracts principal uint)  ;; Now stores coverage amount
(define-map claims { contract: principal, claimant: principal } { amount: uint, status: (string-ascii 20) })

;; Public Functions
(define-public (contribute)
    (let ((amount (stx-get-balance tx-sender)))
        (if (> amount u0)
            (begin
                (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
                (map-set contributors tx-sender (+ (default-to u0 (map-get? contributors tx-sender)) amount))
                (var-set insurance-pool (+ (var-get insurance-pool) amount))
                (ok true)
            )
            ERR_INSUFFICIENT_BALANCE
        )
    )
)

(define-public (register-contract (contract principal) (coverage uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (map-set insured-contracts contract coverage)
        (ok true)
    )
)

(define-public (file-claim (contract principal) (amount uint))
    (let ((coverage (default-to u0 (map-get? insured-contracts contract))))
        (asserts! (> coverage u0) ERR_INVALID_CONTRACT)
        (asserts! (<= amount coverage) ERR_INSUFFICIENT_BALANCE)
        (asserts! (is-none (map-get? claims { contract: contract, claimant: tx-sender })) ERR_CLAIM_ALREADY_EXISTS)
        (ok (map-set claims { contract: contract, claimant: tx-sender } { amount: amount, status: "pending" }))
    )
)

(define-public (approve-claim (contract principal) (claimant principal))
    (let ((claim (unwrap! (map-get? claims { contract: contract, claimant: claimant }) ERR_NO_CLAIM_EXISTS)))
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-eq (get status claim) "pending") ERR_INVALID_CONTRACT)
        (try! (as-contract (stx-transfer? (get amount claim) tx-sender claimant)))
        (var-set insurance-pool (- (var-get insurance-pool) (get amount claim)))
        (ok (map-set claims { contract: contract, claimant: claimant } (merge claim { status: "approved" })))
    )
)

(define-public (reject-claim (contract principal) (claimant principal))
    (let ((claim (unwrap! (map-get? claims { contract: contract, claimant: claimant }) ERR_NO_CLAIM_EXISTS)))
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-eq (get status claim) "pending") ERR_INVALID_CONTRACT)
        (ok (map-set claims { contract: contract, claimant: claimant } (merge claim { status: "rejected" })))
    )
)

;; Read-only Functions
(define-read-only (get-pool-balance)
    (var-get insurance-pool)
)

(define-read-only (is-contract-insured (contract principal))
    (is-some (map-get? insured-contracts contract))
)

(define-read-only (get-contribution (contributor principal))
    (default-to u0 (map-get? contributors contributor))
)

(define-read-only (get-claim-status (contract principal) (claimant principal))
    (get status (default-to { amount: u0, status: "not-found" } (map-get? claims { contract: contract, claimant: claimant })))
)

(define-read-only (get-contract-coverage (contract principal))
    (default-to u0 (map-get? insured-contracts contract))
)
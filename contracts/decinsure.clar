;; Decentralized Insurance Mechanism for Smart Contract Failures
;; Initial Commit

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INSUFFICIENT_BALANCE (err u101))

;; Data Variables
(define-data-var insurance-pool uint u0)

;; Maps
(define-map contributors principal uint)
(define-map insured-contracts principal bool)

;; Public Functions
(define-public (contribute)
    (let ((amount (stx-get-balance tx-sender)))
        (if (> amount u0)
            (begin
                (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
                (map-set contributors tx-sender amount)
                (var-set insurance-pool (+ (var-get insurance-pool) amount))
                (ok true)
            )
            ERR_INSUFFICIENT_BALANCE
        )
    )
)

(define-public (register-contract (contract principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (map-set insured-contracts contract true)
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-pool-balance)
    (var-get insurance-pool)
)

(define-read-only (is-contract-insured (contract principal))
    (default-to false (map-get? insured-contracts contract))
)

(define-read-only (get-contribution (contributor principal))
    (default-to u0 (map-get? contributors contributor))
)
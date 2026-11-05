package ma.ahmedbenidar.tp15.dto;

import ma.ahmedbenidar.tp15.entites.TypeTransaction;

public record TransactionRequest(
        Long compteId,
        double montant,
        String date,
        TypeTransaction type
) {
}

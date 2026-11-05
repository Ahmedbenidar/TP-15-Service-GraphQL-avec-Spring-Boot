package ma.ahmedbenidar.tp15.dto;

import ma.ahmedbenidar.tp15.entites.TypeTransaction;

public record TransactionVue(
        Long id,
        double montant,
        String date,
        TypeTransaction type,
        CompteVue compte
) {
}

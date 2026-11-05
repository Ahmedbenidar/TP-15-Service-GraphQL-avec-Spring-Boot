package ma.ahmedbenidar.tp15.dto;

import ma.ahmedbenidar.tp15.entites.TypeCompte;

public record CompteRequest(
        String titulaire,
        double solde,
        String dateCreation,
        TypeCompte type
) {
}

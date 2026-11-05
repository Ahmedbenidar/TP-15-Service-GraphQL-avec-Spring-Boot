package ma.ahmedbenidar.tp15.amorce;

import ma.ahmedbenidar.tp15.depots.CompteDepot;
import ma.ahmedbenidar.tp15.depots.TransactionDepot;
import ma.ahmedbenidar.tp15.entites.Compte;
import ma.ahmedbenidar.tp15.entites.Transaction;
import ma.ahmedbenidar.tp15.entites.TypeCompte;
import ma.ahmedbenidar.tp15.entites.TypeTransaction;
import ma.ahmedbenidar.tp15.outils.ConvertisseurDates;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AmorceBanque implements CommandLineRunner {

    private static final Logger JOURNAL = LoggerFactory.getLogger(AmorceBanque.class);

    private final CompteDepot compteDepot;
    private final TransactionDepot transactionDepot;

    public AmorceBanque(CompteDepot compteDepot, TransactionDepot transactionDepot) {
        this.compteDepot = compteDepot;
        this.transactionDepot = transactionDepot;
    }

    @Override
    public void run(String... args) {
        if (compteDepot.count() > 0) {
            return;
        }

        List<Compte> comptes = List.of(
                compte("Ahmed Benidar", 18500.00, "2024-01-15", TypeCompte.COURANT),
                compte("Salma El Fassi", 72350.50, "2024-02-03", TypeCompte.EPARGNE),
                compte("Youssef Ouazzani", 9400.75, "2024-03-21", TypeCompte.COURANT),
                compte("Nadia Bouhaddou", 152000.00, "2024-04-08", TypeCompte.EPARGNE),
                compte("Karim Tazi", 32680.25, "2024-05-30", TypeCompte.PROFESSIONNEL),
                compte("Imane Cherkaoui", 5100.00, "2024-06-12", TypeCompte.COURANT)
        );
        compteDepot.saveAll(comptes);

        transactionDepot.saveAll(List.of(
                transaction(4500.00, "2024-07-05", TypeTransaction.DEPOT, comptes.get(0)),
                transaction(1200.00, "2024-07-19", TypeTransaction.RETRAIT, comptes.get(0)),
                transaction(15000.00, "2024-08-02", TypeTransaction.DEPOT, comptes.get(1)),
                transaction(2500.50, "2024-08-16", TypeTransaction.RETRAIT, comptes.get(1)),
                transaction(800.00, "2024-09-01", TypeTransaction.DEPOT, comptes.get(4))
        ));

        JOURNAL.info("Amorcage termine : {} comptes et {} transactions de demonstration",
                compteDepot.count(), transactionDepot.count());
    }

    private Compte compte(String titulaire, double solde, String date, TypeCompte type) {
        Compte compte = new Compte();
        compte.setTitulaire(titulaire);
        compte.setSolde(solde);
        compte.setDateCreation(ConvertisseurDates.versDate(date));
        compte.setType(type);
        return compte;
    }

    private Transaction transaction(double montant, String date, TypeTransaction type, Compte compte) {
        Transaction transaction = new Transaction();
        transaction.setMontant(montant);
        transaction.setDate(ConvertisseurDates.versDate(date));
        transaction.setType(type);
        transaction.setCompte(compte);
        return transaction;
    }
}

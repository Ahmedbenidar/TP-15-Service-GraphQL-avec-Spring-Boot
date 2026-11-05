# TP 15 - Service GraphQL avec Spring Boot


## 1. Outils utilises

Java 21 et Maven 3.9.9 ont servi a construire et a lancer le projet. Les versions
exactes relevees sur la machine sont affichees ci-dessous.

![Versions des outils](docs/captures/00-versions-outils.png)

---

## 2. Compilation et packaging

Le projet produit un jar executable. La commande Maven nettoie le dossier de
sortie, compile les seize sources, passe les tests puis fabrique une archive
autonome avec Tomcat embarque. Le journal se termine par la confirmation de
compilation reussie.

![Build Maven](docs/captures/build-maven.png)

---

## 3. Demarrage du service

Le jar demarre Tomcat sur le port 8085. Le journal montre le chargement du
fichier de schema GraphQL, la publication du point d acces POST graphql,
l ouverture de la console H2 sur la base en memoire et l amorcage de six comptes
avec cinq transactions. Le service est pret en douze secondes.

![Demarrage](docs/captures/demarrage-service.png)

---

## 4. Le contrat GraphQL

Le schema est decrit dans un seul fichier SDL. GraphiQL est active sur le
service et affiche la documentation complete generee a partir de ce fichier. On
y retrouve les neuf requetes, les trois mutations et tous les types metier.

![Documentation GraphiQL](docs/captures/graphiql-11-documentation.png)

Le type Compte expose ses champs ainsi que la liste de ses transactions, ce qui
permet de recuperer un compte et ses mouvements en un seul appel.

![Schema du type Compte](docs/captures/graphiql-12-schema-compte.png)

---

## 5. Lecture des comptes

Le premier appel renvoie les six comptes amorces avec leur titulaire, leur
solde, leur date de creation au format jour mois annee et leur type.

![allComptes](docs/captures/01-requete-allComptes.png)

La meme requete lancee dans GraphiQL donne exactement le meme resultat, avec la
colonne de gauche pour la requete et la colonne de droite pour la reponse.

![allComptes dans GraphiQL](docs/captures/graphiql-01-allComptes.png)

---

## 6. Consultation d un compte

La consultation par identifiant remonte le compte demande avec la liste de ses
transactions imbriquees. Aucun deuxieme appel n est necessaire.

![compteById](docs/captures/02-requete-compteById.png)

![compteById dans GraphiQL](docs/captures/graphiql-02-compteById.png)

L identifiant peut aussi etre passe en variable, ce qui evite de reecrire la
requete a chaque essai. La variable vaut ici quatre et la reponse renvoie bien la
cliente correspondante.

![compteById avec variable](docs/captures/03-requete-variables.png)

![Variables dans GraphiQL](docs/captures/graphiql-04-variables.png)

---

## 7. Erreurs propres

Un identifiant inexistant ne casse pas le service. La reponse contient un bloc
d erreurs avec un message lisible, la position dans la requete et une
classification mauvaise requete, sans aucune trace technique.

![Compte introuvable](docs/captures/04-erreur-compte-introuvable.png)

![Compte introuvable dans GraphiQL](docs/captures/graphiql-03-erreur.png)

---

## 8. Creation d un compte

La mutation de creation ajoute un compte reel, lui attribue un identifiant et
renvoie l enregistrement complet avec sa date normalisee.

![saveCompte](docs/captures/05-mutation-saveCompte.png)

![saveCompte dans GraphiQL](docs/captures/graphiql-05-mutation-saveCompte.png)

Une creation avec un solde negatif est refusee par la validation metier. La
reponse reste structuree et classe l erreur en mauvaise requete.

![Solde negatif refuse](docs/captures/06-erreur-solde-negatif.png)

---

## 9. Statistiques de solde

La requete d agregation renvoie le nombre de comptes, la somme totale, la
moyenne, le solde maximal et le solde minimal en un seul aller retour.

![totalSolde](docs/captures/07-requete-totalSolde.png)

![totalSolde dans GraphiQL](docs/captures/graphiql-06-totalSolde.png)

---

## 10. Filtres et recherche

Le filtre par type isole les comptes professionnels, un troisieme type ajoute en
plus des deux types du sujet de base.

![comptesParType](docs/captures/08-requete-comptesParType.png)

La recherche par fragment de titulaire ignore la casse et retrouve la cliente
dont le nom contient les lettres demandees.

![Recherche par titulaire](docs/captures/09-requete-recherche.png)

---

## 11. Tableau de bord

La requete de synthese rassemble en une seule reponse le nombre de comptes, le
nombre de transactions, le solde total et la repartition par type avec le nombre
de comptes et le solde cumule de chaque type.

![tableauBord](docs/captures/10-requete-tableauBord.png)

![tableauBord dans GraphiQL](docs/captures/graphiql-07-tableauBord.png)

---

## 12. Mouvements et controle de decouvert

Un versement cree une transaction et met a jour le solde du compte dans la meme
operation. La reponse renvoie la transaction et le compte recalcule, dont le
solde passe de neuf mille quatre cents a onze mille six cents.

![Depot](docs/captures/11-mutation-addDepot.png)

![Depot dans GraphiQL](docs/captures/graphiql-08-mutation-depot.png)

Un retrait superieur au solde disponible est refuse. Le message indique le
compte concerne et la classification reste mauvaise requete. Aucune somme n est
retiree.

![Retrait refuse](docs/captures/12-erreur-retrait-refuse.png)

![Retrait refuse dans GraphiQL](docs/captures/graphiql-09-retrait-refuse.png)

---

## 13. Transactions

Les transactions d un compte se lisent directement depuis le compte ou via une
requete dediee triee par date decroissante.

![Transactions d un compte](docs/captures/13-requete-transactions.png)

La liste complete des transactions inclut pour chacune le compte de rattachement
avec son identifiant et son titulaire.

![Toutes les transactions](docs/captures/14-requete-allTransactions.png)

![Toutes les transactions dans GraphiQL](docs/captures/graphiql-10-allTransactions.png)

Les statistiques de transactions donnent le nombre de mouvements, le total des
depots, le total des retraits et le solde net, ici dix-huit mille sept cent
quatre-vingt-dix-neuf.

![Statistiques transactions](docs/captures/15-requete-transactionStats.png)

---

## 14. Suppression et controle final

La suppression d un compte existant renvoie vrai. Appliquee a un identifiant
inexistant, elle renvoie une erreur lisible au lieu d un plantage.

![Suppression](docs/captures/16-mutation-suppression.png)

![Suppression impossible](docs/captures/17-erreur-suppression.png)

Le controle final confirme que la base est revenue a six comptes, avec le solde
total recalcule apres le versement et la suppression.

![Etat final](docs/captures/18-etat-final.png)

---

## 15. Verification directe dans la base

La console H2 est activee et permet de verifier le contenu reel des tables sans
passer par le service. La table des comptes montre les six titulaires avec leur
solde, leur type et leur date de creation.

![Table COMPTE](docs/captures/h2-01-table-compte.png)

La table des transactions confirme les six mouvements persistes, avec le compte
de rattachement de chacun.

![Table TRANSACTION](docs/captures/h2-02-table-transaction.png)

---

param(
    [string]$Racine = "C:\Users\dell\Desktop\tp15_graphql_spring"
)

$uri = "http://localhost:8085/graphql"
$logs = Join-Path $Racine "docs\logs"
$tmp = Join-Path $Racine "tmp"
if (!(Test-Path $tmp)) { New-Item -ItemType Directory -Force -Path $tmp | Out-Null }

function Executer {
    param([string]$Nom, [string]$Requete, [string]$Variables = $null)

    $corps = [ordered]@{ query = $Requete }
    if ($Variables) { $corps.variables = ($Variables | ConvertFrom-Json) }
    $fichier = Join-Path $tmp "$Nom.json"
    $json = $corps | ConvertTo-Json -Compress -Depth 8
    [System.IO.File]::WriteAllText($fichier, $json, (New-Object System.Text.UTF8Encoding $false))

    $sortie = Join-Path $logs "$Nom.txt"
    "[$] curl -s -X POST $uri -H Content-Type:application/json --data-binary @$Nom.json" | Out-File -FilePath $sortie -Encoding utf8
    "---- REQUETE ----" | Out-File -FilePath $sortie -Encoding utf8 -Append
    $json | Out-File -FilePath $sortie -Encoding utf8 -Append
    "---- REPONSE ----" | Out-File -FilePath $sortie -Encoding utf8 -Append
    $reponse = & curl.exe -s -X POST $uri -H "Content-Type: application/json" --data-binary "@$fichier"
    $reponse | Out-File -FilePath $sortie -Encoding utf8 -Append
    Write-Output "########## $Nom ##########"
    Write-Output $reponse
    Write-Output ""
}

Executer "01-allComptes" 'query { allComptes { id titulaire solde dateCreation type } }'
Executer "02-compteById" 'query { compteById(id: 1) { id titulaire solde dateCreation type transactions { id montant type } } }'
Executer "03-compteVariables" 'query VoirCompte($id: ID) { compteById(id: $id) { id titulaire solde type } }' '{"id": 4}'
Executer "04-compteIntrouvable" 'query { compteById(id: 42) { id titulaire } }'
Executer "05-saveCompte" 'mutation { saveCompte(compte: { titulaire: "Hakim Bennani", solde: 12500.0, dateCreation: "2024/11/18", type: COURANT }) { id titulaire solde dateCreation type } }'
Executer "06-soldeNegatif" 'mutation { saveCompte(compte: { titulaire: "Essai Rejete", solde: -75.0, dateCreation: "2024/12/01", type: EPARGNE }) { id } }'
Executer "07-totalSolde" 'query { totalSolde { count sum average max min } }'
Executer "08-comptesParType" 'query { comptesParType(type: PROFESSIONNEL) { id titulaire solde type } }'
Executer "09-recherche" 'query { rechercherComptes(fragment: "el") { id titulaire solde type } }'
Executer "10-tableauBord" 'query { tableauBord { nombreComptes nombreTransactions soldeTotal repartition { type nombre solde } } }'
Executer "11-addDepot" 'mutation { addTransaction(transaction: { compteId: 3, montant: 2200.0, date: "2024/12/05", type: DEPOT }) { id montant date type compte { id titulaire solde } } }'
Executer "12-retraitRefuse" 'mutation { addTransaction(transaction: { compteId: 6, montant: 99000.0, date: "2024/12/06", type: RETRAIT }) { id montant } }'
Executer "13-compteTransactions" 'query { compteTransactions(id: 3) { id montant date type } }'
Executer "14-allTransactions" 'query { allTransactions { id montant date type compte { id titulaire } } }'
Executer "15-transactionStats" 'query { transactionStats { count sumDepots sumRetraits soldeNet } }'
Executer "16-supprimerCompte" 'mutation { supprimerCompte(id: 7) }'
Executer "17-suppressionInvalide" 'mutation { supprimerCompte(id: 77) }'
Executer "18-etatFinal" 'query { allComptes { id titulaire solde type } totalSolde { count sum } transactionStats { count soldeNet } }'

Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "=== TERMINE ==="

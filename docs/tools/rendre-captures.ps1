param(
    [string]$Racine = "C:\Users\dell\Desktop\tp15_graphql_spring"
)

$logs = Join-Path $Racine "docs\logs"
$captures = Join-Path $Racine "docs\captures"
$tmp = Join-Path $Racine "tmp\apercus"
New-Item -ItemType Directory -Force -Path $captures | Out-Null
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$rendu = Join-Path $Racine "docs\tools\console-vers-png.ps1"

function JolieJson([string]$texte) {
    try {
        $obj = $texte | ConvertFrom-Json
        return ($obj | ConvertTo-Json -Depth 12)
    } catch {
        return $texte
    }
}

$plan = @(
    @{ F = "01-allComptes";        P = "01-requete-allComptes";         T = "GraphQL - requete allComptes" },
    @{ F = "02-compteById";        P = "02-requete-compteById";         T = "GraphQL - compteById avec ses transactions" },
    @{ F = "03-compteVariables";   P = "03-requete-variables";          T = "GraphQL - compteById avec variable" },
    @{ F = "04-compteIntrouvable"; P = "04-erreur-compte-introuvable";  T = "GraphQL - erreur compte introuvable" },
    @{ F = "05-saveCompte";        P = "05-mutation-saveCompte";        T = "GraphQL - mutation saveCompte" },
    @{ F = "06-soldeNegatif";      P = "06-erreur-solde-negatif";       T = "GraphQL - validation solde negatif" },
    @{ F = "07-totalSolde";        P = "07-requete-totalSolde";         T = "GraphQL - statistiques totalSolde" },
    @{ F = "08-comptesParType";    P = "08-requete-comptesParType";     T = "GraphQL - filtre comptesParType" },
    @{ F = "09-recherche";         P = "09-requete-recherche";          T = "GraphQL - recherche par titulaire" },
    @{ F = "10-tableauBord";       P = "10-requete-tableauBord";        T = "GraphQL - tableau de bord" },
    @{ F = "11-addDepot";          P = "11-mutation-addDepot";          T = "GraphQL - mutation depot" },
    @{ F = "12-retraitRefuse";     P = "12-erreur-retrait-refuse";      T = "GraphQL - retrait refuse" },
    @{ F = "13-compteTransactions";P = "13-requete-transactions";       T = "GraphQL - transactions d un compte" },
    @{ F = "14-allTransactions";   P = "14-requete-allTransactions";    T = "GraphQL - toutes les transactions" },
    @{ F = "15-transactionStats";  P = "15-requete-transactionStats";   T = "GraphQL - statistiques transactions" },
    @{ F = "16-supprimerCompte";   P = "16-mutation-suppression";       T = "GraphQL - suppression d un compte" },
    @{ F = "17-suppressionInvalide"; P = "17-erreur-suppression";       T = "GraphQL - suppression impossible" },
    @{ F = "18-etatFinal";         P = "18-etat-final";                 T = "GraphQL - etat final de la base" }
)

foreach ($item in $plan) {
    $source = Join-Path $logs ($item.F + ".txt")
    $lignes = [System.IO.File]::ReadAllLines($source)
    $sortie = New-Object System.Collections.Generic.List[string]
    $enReponse = $false
    foreach ($l in $lignes) {
        if ($l -match '^---- REPONSE ----') { $enReponse = $true; $sortie.Add("---- REPONSE ----"); continue }
        if ($l -match '^---- REQUETE ----') { $enReponse = $false; $sortie.Add("---- REQUETE ----"); continue }
        if ($enReponse -and $l.Trim().Length -gt 0) {
            foreach ($x in (JolieJson $l).Split("`n")) { $sortie.Add($x.TrimEnd()) }
        } else {
            $sortie.Add($l.TrimEnd())
        }
    }
    $apercu = Join-Path $tmp ($item.F + ".txt")
    [System.IO.File]::WriteAllLines($apercu, $sortie, (New-Object System.Text.UTF8Encoding $false))
    & powershell -NoProfile -ExecutionPolicy Bypass -File $rendu -Entree $apercu -Sortie (Join-Path $captures ($item.P + ".png")) -Titre $item.T -LargeurMax 120 -TaillePolice 13
}

Write-Output "=== CAPTURES TERMINEES ==="

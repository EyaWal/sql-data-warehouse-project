# Data Warehouse & Analytics Project

Projet de data warehouse moderne avec SQL Server, réalisé sur macOS : intégration de
deux sources (ERP et CRM), pipelines ETL, modèle en étoile et analyses SQL.

## 🏗️ Architecture
![Architecture des données](docs/data_architecture.png)

Architecture Medallion en trois couches :
- **Bronze** : données brutes des fichiers CSV, chargées telles quelles
- **Silver** : données nettoyées, standardisées et normalisées
- **Gold** : données prêtes pour le métier, modélisées en schéma en étoile (faits + dimensions)

## 🎯 Ce que j'ai réalisé
- Pipelines ETL (chargement en masse → transformations → vues)
- Modélisation des données : tables de faits et de dimensions
- Analyses SQL : comportement client, performance produit, tendances des ventes

## 🛠️ Stack technique
- **SQL Server** (image Docker officielle) ⚠️ à adapter : version utilisée
- **Docker Desktop** : exécution de SQL Server sur macOS
- **Client SQL** : ⚠️ à adapter (VS Code + extension MSSQL, DBeaver, DataGrip…)
- **Git/GitHub** : versionnement
- **Draw.io** : schémas d'architecture et de modélisation

## 💻 Installation sur Mac
SSMS n'existe pas sur macOS : SQL Server tourne dans un conteneur Docker, et on s'y
connecte avec un client SQL.

1. Installer [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Lancer SQL Server (⚠️ à adapter selon ton tutoriel) :
```bash
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<MotDePasse>" \
     -p 1433:1433 --name sqlserver \
     -v "$(pwd)/datasets:/var/opt/mssql/datasets" \
     -d mcr.microsoft.com/mssql/server:2022-latest
```
   > Sur Mac Apple Silicon (M1/M2/M3/M4), ajouter `--platform linux/amd64` si l'image ne démarre pas.
3. Se connecter avec ton client SQL : serveur `localhost,1433`, utilisateur `sa`
4. Le volume `-v` rend les CSV accessibles dans le conteneur, ce qui est nécessaire
   pour `BULK INSERT` (chemin utilisé dans les scripts : `/var/opt/mssql/datasets/...`)

## ▶️ Comment exécuter le projet
1. Cloner le repository
2. Démarrer le conteneur SQL Server (voir ci-dessus)
3. Exécuter les scripts dans l'ordre :
   1. `scripts/init_database.sql` (création de la base et des schémas)
   2. `scripts/bronze/` (chargement des données brutes)
   3. `scripts/silver/` (nettoyage et transformation)
   4. `scripts/gold/` (création du modèle analytique)

## 📂 Structure du repository
```
├── datasets/    # fichiers CSV sources (ERP, CRM)
├── docs/        # schémas, catalogue de données, conventions de nommage
├── scripts/
│   ├── bronze/  # chargement des données brutes
│   ├── silver/  # nettoyage et transformation
│   └── gold/    # création du modèle analytique
├── tests/       # contrôles de qualité des données
└── README.md
```

## 📊 Résultats et enseignements
(2-3 captures d'écran ou conclusions clés tirées de tes requêtes d'analyse)

## 🧠 Ce que j'ai appris
(Difficultés rencontrées, par exemple l'installation sur Mac, les problèmes de qualité de données, les choix de modélisation)

## 🙏 Crédits
Projet réalisé à partir du cours de [Data With Baraa](https://github.com/DataWithBaraa/sql-data-warehouse-project).

## 👤 À propos
Eya, [LinkedIn](...)
import csv
import sys
import os
import argparse


def check_csv_columns(file_path, delimiter, verbose=True):
    """
    Vérifie que chaque ligne d'un fichier CSV a le même nombre de colonnes.

    Parameters:
    ----------
    file_path : str
        Le chemin du fichier CSV à vérifier.
    delimiter : str
        Le délimiteur utilisé dans le fichier CSV (',' ou ';').
    verbose : bool, optional
        Si True, affiche les messages de statut (par défaut True).

    Returns:
    -------
    bool
        True si toutes les lignes ont le même nombre de colonnes, False sinon.

    Raises:
    ------
    ValueError:
        Si une ligne n'a pas le même nombre de colonnes que la première ligne.
    """
    try:
        with open(file_path, mode="r", newline="", encoding="utf-8") as csvfile:
            csv_reader = csv.reader(
                csvfile, delimiter=delimiter
            )  # Utilisation du délimiteur spécifié

            # Lire la première ligne pour obtenir le nombre de colonnes attendu
            first_row = next(csv_reader)
            num_columns = len(first_row)

            # Vérifier le nombre de colonnes pour chaque ligne suivante
            for line_number, row in enumerate(csv_reader, start=2):
                if len(row) != num_columns:
                    raise ValueError(
                        f"Erreur à la ligne {line_number}: {len(row)} colonnes trouvées, "
                        f"mais {num_columns} colonnes attendues."
                    )

        if verbose:
            print(
                f"Toutes les lignes ont le même nombre de colonnes ({num_columns} colonnes)."
            )
        return True

    except ValueError as ve:
        if verbose:
            print(ve)
        return False
    except FileNotFoundError:
        if verbose:
            print(f"Erreur: Le fichier '{file_path}' est introuvable.")
        return False
    except Exception as e:
        if verbose:
            print(f"Une erreur inattendue est survenue: {str(e)}")
        return False


def main():
    """
    Point d'entrée principal du programme. Gère les arguments et lance la vérification du fichier CSV.
    """
    # Configuration du parser d'arguments
    parser = argparse.ArgumentParser(
        description="Vérification du nombre de colonnes dans un fichier CSV."
    )
    parser.add_argument(
        "-f", "--infile", required=True, help="Le chemin du fichier CSV à traiter."
    )
    parser.add_argument(
        "-s",
        "--sep",
        default=";",
        choices=[",", ";"],
        help="Séparateur du CSV: ',' ou ';' (par défaut ';').",
    )
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_true",
        help="Mode silencieux (aucune sortie sur la console).",
    )

    # Analyse des arguments
    args = parser.parse_args()

    # Vérification si le fichier existe
    if not os.path.isfile(args.infile):
        if not args.quiet:
            print(f"Erreur: Le fichier '{args.infile}' n'existe pas.")
        sys.exit(1)

    # Exécution de la vérification du fichier CSV
    result = check_csv_columns(args.infile, args.sep, verbose=not args.quiet)

    if result:
        sys.exit(0)  # Sortie avec succès si toutes les colonnes correspondent
    else:
        sys.exit(1)  # Sortie avec une erreur si la vérification échoue


if __name__ == "__main__":
    main()

import sqlite3

# Database setup
DATABASE = 'targets.db'

def find_and_remove_duplicates(conn):
    """Find and remove duplicate emails from the emails table."""
    cursor = conn.cursor()

    # Step 1: Find duplicate emails
    print("Searching for duplicate emails...")
    cursor.execute('''
        SELECT email, COUNT(*) as count
        FROM emails
        GROUP BY email
        HAVING count > 1
    ''')
    duplicates = cursor.fetchall()

    if not duplicates:
        print("No duplicate emails found.")
        return

    print(f"Found {len(duplicates)} email(s) with duplicates.")

    # Step 2: Remove duplicates, keeping only one occurrence
    for email, count in duplicates:
        print(f"Processing email: {email} (found {count} times)")

        # Find the first occurrence of the email (minimum rowid)
        cursor.execute('''
            SELECT MIN(rowid)
            FROM emails
            WHERE email = ?
        ''', (email,))
        min_rowid = cursor.fetchone()[0]

        # Delete all occurrences of the email except the first one
        cursor.execute('''
            DELETE FROM emails
            WHERE email = ? AND rowid != ?
        ''', (email, min_rowid))

        print(f"Removed {count - 1} duplicate(s) for email: {email}")

    # Commit the changes to the database
    conn.commit()
    print("Duplicate removal completed.")

def main():
    # Connect to the database
    conn = sqlite3.connect(DATABASE)

    # Find and remove duplicates
    find_and_remove_duplicates(conn)

    # Close the database connection
    conn.close()
    print("Database connection closed.")

if __name__ == "__main__":
    main()

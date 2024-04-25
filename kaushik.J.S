import sqlite3

def create_connection(db_file):
    """ create a database connection to the SQLite database specified by db_file """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except sqlite3.Error as e:
        print(e)
    return conn

def create_table(conn):
    """ create a table from the create_table_sql statement """
    try:
        sql_create_books_table = """ CREATE TABLE IF NOT EXISTS books (
                                        id integer PRIMARY KEY,
                                        name text NOT NULL,
                                        author text NOT NULL
                                    ); """
        c = conn.cursor()
        c.execute(sql_create_books_table)
    except sqlite3.Error as e:
        print(e)

def add_book(conn, book):
    """
    Create a new book into the books table
    :param conn:
    :param book:
    :return: book id
    """
    sql = ''' INSERT INTO books(name, author)
              VALUES(?,?) '''
    cur = conn.cursor()
    cur.execute(sql, book)
    conn.commit()
    return cur.lastrowid

def select_all_books(conn):
    """
    Query all rows in the books table
    """
    cur = conn.cursor()
    cur.execute("SELECT * FROM books")

    rows = cur.fetchall()
    for row in rows:
        print(row)
def main():
    database = "books.db"

    # create a database connection
    conn = create_connection(database)
    if conn is not None:
        # create books table
        create_table(conn)

        # add books
        book1 = ('Alice in Wonderland', 'Lewis Carroll')
        book2 = ('The Great Gatsby', 'F. Scott Fitzgerald')
        
        add_book(conn, book1)
        add_book(conn, book2)

        # show all books
        print("Books in database:")
        select_all_books(conn)

        # close connection
        conn.close()
    else:
        print("Error! cannot create the database connection.")

if _name_ == '_main_':
    main()

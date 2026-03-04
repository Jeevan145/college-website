import mysql.connector

def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="naya@123jeev",
        database="svp_college"
    )

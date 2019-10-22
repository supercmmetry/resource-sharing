import os
import sqlite3
from sqlite3 import Error
import json


def getpubstr(x):
    if x == '0':
        return "(public)"
    elif x == '1':
        return "(private)"
    else:
        return "(NA)"

def getConnectionDB():
    conn = None
    if not os.path.exists("./data.db"):
        conn = sqlite3.connect("./data.db")
        cur = conn.cursor()
        db_init_file = open("./res/db_init.sql", "r")
        cur.execute(db_init_file.read())
        cur.execute('''CREATE TABLE IF NOT EXISTS resources (
            filename text PRIMARY KEY,
            public text NOT NULL
        );''')
        
        conn.commit()
        db_init_file.close()
    else:
        conn = sqlite3.connect("./data.db")
    conn.row_factory = sqlite3.Row
    return conn

conn = getConnectionDB()

def getDefaultProfilePictureUrl():
    return "file:///" + os.path.join(os.path.dirname(__file__), "res", "default_profile_picture.jpg")

def getContactsFromDB():
    cur = conn.cursor()
    cur.execute("SELECT * FROM contacts")
    rows = cur.fetchall()
    model_data = []
    url = getDefaultProfilePictureUrl()
    for row in rows:
        model_data.append({"name": row["name"], "dhtId": row["ip"], "imageUrl": url})
    return model_data

def addContactToDB(ip, name):
    sql_query = f"insert into contacts (ip, name) values ('{ip}', '{name}')"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def addExtFileToDB(filename):
    sql_query = f"insert into resources (filename, public) values ('{filename}', 0)"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def addIntFileToDB(filename):
    sql_query = f"insert into resources (filename, public) values ('{filename}', 0)"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def removeFileDB(filename):
    sql_query = f"delete from resources where filename={filename}"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def getPublicFilesDB():
    sql_query = f"select filename from resources where public=0"
    cur = conn.cursor()
    cur.execute(sql_query)
    rows = cur.fetchall()
    files = []
    for row in rows:
        files.append(row["filename"])
    return files


def getPublicFilesDB_thread():
    conn_t = getConnectionDB()
    sql_query = f"select filename from resources where public=0"
    cur = conn_t.cursor()
    cur.execute(sql_query)
    rows = cur.fetchall()
    files = []
    for row in rows:
        files.append(row["filename"])
    conn_t.close()
    return files


def getFilesDB():
    sql_query = f"select filename, public from resources"
    cur = conn.cursor()
    cur.execute(sql_query)
    rows = cur.fetchall()
    files = []
    for row in rows:
        files.append({'name': row["filename"], 'pubstr': getpubstr(row["public"])})
    return files


def removeFile(filename):
    sql_query = f"delete from resources where filename='{filename}'"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def makePublic(filename):
    sql_query = f"update resources set public=0 where filename='{filename}'"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def makePrivate(filename):
    sql_query = f"update resources set public=1 where filename='{filename}'"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()


def convlisttojson(ls):
    wrapper = {"result": ls}
    return json.dumps(wrapper)


def convjsontolist(js):
    return json.loads(js)["result"]


def createDir(dirname):
    if not os.path.isdir(dirname):
        os.makedirs(dirname)

def getFileName(filename):
    return filename.split('/')[-1]

def deleteContact(ip):
    sql_query = f"delete from contacts where ip='{ip}'"
    cur = conn.cursor()
    cur.execute(sql_query)
    conn.commit()
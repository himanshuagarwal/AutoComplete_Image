#!/usr/bin/python2
print("Content-Type: text/html")
print("")
import cgi, os
import cgitb; cgitb.enable()
import commands as sp
form = cgi.FieldStorage()

UPLOAD_DIR = '/home/himanshuagarwal272/AutoComplete_Image/input'
# A nested FieldStorage instance holds the file
form_file = form["imginp"]

from PIL import Image, ImageFilter

print("<html><head><title>AutoComplete_Image</title></head><body>")
#print("<h5>"+str(len(form))+"</h5>")
if not form_file.file:
    print '<h1>Not found parameter: file</h1>'

if  not form_file.filename:
    print '<h1>Not found parameter: filename</h1>'

uploaded_file_path = os.path.join(UPLOAD_DIR, os.path.basename(form_file.filename))
fout = open(uploaded_file_path, 'wb')
while True:
    chunk = form_file.file.read(100000)
    if not chunk:
        break
    fout.write (chunk)
print '<h5>Completed file upload</h5>'
print '<a href="/images/'+form_file.filename+'">View Results</a>'
#print sp.getoutput("python /home/himanshuagarwal272/AutoComplete_Image/final.py")


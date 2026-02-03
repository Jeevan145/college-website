from flask import Flask, render_template, request, redirect, session, send_file
import hashlib
import random

from db import get_db
from pdf_utils import generate_admission_letter, generate_fee_receipt

app = Flask(__name__)
app.secret_key = "svp_super_secret_key_123"
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "static/uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


@app.route("/")
def root():
    return redirect("/home")

# =========================
# HOME PAGE (INDEX)
# =========================
@app.route("/home")
def home():
    return render_template("index.html")


# =========================
# LOGIN (ADMIN / STUDENT)
# =========================
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        role = request.form["role"]
        username = request.form["username"]
        password = hashlib.sha256(
            request.form["password"].encode()
        ).hexdigest()

        db = get_db()
        cur = db.cursor(dictionary=True)

        # ================= ADMIN LOGIN =================
        if role == "admin":
            cur.execute(
                "SELECT * FROM admins WHERE username=%s AND password_hash=%s",
                (username, password)
            )
            admin = cur.fetchone()

            if admin:
                session.clear()
                session["admin"] = admin["username"]
                return redirect("/admin")

            return "❌ Invalid Admin Credentials"

        # ================= STUDENT LOGIN =================
        elif role == "student":
            cur.execute("""
                SELECT * FROM students
                WHERE admission_id=%s
                AND password_hash=%s
            """, (username, password))

            student = cur.fetchone()

            if not student:
                return "❌ Invalid Student Credentials"

            if student["status"] == "ACTIVE":
                session.clear()
                session["student"] = student["admission_id"]
                return redirect("/student")

            elif student["status"] == "REJECTED":
                return render_template(
                    "student_rejected.html",
                    reason=student.get("rejection_reason")
                )

            else:
                return render_template("student_pending.html")

        return "❌ Invalid Login Request"

    return render_template("login.html")



# =========================
# LOGOUT
# =========================
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


# =========================
# ADMIN DASHBOARD
# =========================
@app.route("/admin")
def admin_dashboard():
    if "admin" not in session:
        return redirect("/")
    return render_template("admin_dashboard.html")


# =========================
# ONLINE ADMISSION (PUBLIC)
# =========================

import os
import random
import hashlib
from werkzeug.utils import secure_filename
from flask import request, render_template
from db import get_db
UPLOAD_FOLDER = "static/uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.route("/admission", methods=["GET", "POST"])
def admission():
    if request.method == "POST":
        admission_id = "SVP" + str(random.randint(10000, 99999))

        # PASSWORD (student creates)
        password_hash = hashlib.sha256(
            request.form["password"].encode()
        ).hexdigest()

        # =========================
        # FILE UPLOADS
        # =========================
        photo = request.files["photo"]
        marks_card = request.files["marks_card"]
        caste_cert = request.files["caste_certificate"]
        income_cert = request.files["income_certificate"]

        photo_name = admission_id + "_photo_" + secure_filename(photo.filename)
        marks_name = admission_id + "_marks_" + secure_filename(marks_card.filename)
        caste_name = admission_id + "_caste_" + secure_filename(caste_cert.filename)
        income_name = admission_id + "_income_" + secure_filename(income_cert.filename)

        photo.save(os.path.join(UPLOAD_FOLDER, photo_name))
        marks_card.save(os.path.join(UPLOAD_FOLDER, marks_name))
        caste_cert.save(os.path.join(UPLOAD_FOLDER, caste_name))
        income_cert.save(os.path.join(UPLOAD_FOLDER, income_name))

        # =========================
        # DATABASE INSERTS
        # =========================
        db = get_db()
        cur = db.cursor()

        # 1️⃣ STUDENTS TABLE (LOGIN)
        cur.execute("""
            INSERT INTO students
            (admission_id, student_name, branch, mobile, password_hash, status)
            VALUES (%s,%s,%s,%s,%s,'INACTIVE')
        """, (
            admission_id,
            request.form["student_name"],
            request.form["branch"],
            request.form["student_mobile"],
            password_hash
        ))

        # 2️⃣ STUDENT PERSONAL DETAILS
        cur.execute("""
            INSERT INTO student_personal_details
            (admission_id, student_mobile, student_email,
             indian_nationality, religion, disability,
             aadhaar_number,
             caste_rd_number, caste_certificate_file,
             income_rd_number, income_certificate_file,
             annual_income,
             mother_name, mother_mobile,
             father_name, father_mobile,
             residential_address, permanent_address)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            admission_id,
            request.form["student_mobile"],
            request.form["student_email"],
            request.form["indian_nationality"],
            request.form["religion"],
            request.form["disability"],
            request.form["aadhaar_number"],
            request.form["caste_rd_number"],
            caste_name,
            request.form["income_rd_number"],
            income_name,
            request.form["annual_income"],
            request.form["mother_name"],
            request.form["mother_mobile"],
            request.form["father_name"],
            request.form["father_mobile"],
            request.form["residential_address"],
            request.form["permanent_address"]
        ))

        db.commit()

        return render_template(
            "admission_success.html",
            admission_id=admission_id
        )

    return render_template("admission_form.html")

@app.route("/admission/step-1", methods=["GET", "POST"])
def admission_step1():
    if request.method == "POST":
        admission_id = "SVP" + str(random.randint(10000, 99999))

        session["admission"] = {
            "admission_id": admission_id,

            # Student Personal
            "student_name": request.form["student_name"],
            "student_mobile": request.form["student_mobile"],
            "student_email": request.form["student_email"],
            "dob": request.form["dob"],
            "gender": request.form["gender"],
            "nationality": request.form["nationality"],
            "religion": request.form.get("religion"),
            "caste_category": request.form["caste_category"],
            "allocated_category": request.form["allocated_category"],

            # Academic
            # Academic (Dynamic)
"qualifying_exam": request.form["qualifying_exam"],
"year_of_passing": request.form["year_of_passing"],
"register_number": request.form["register_number"],

# SSLC / PUC Marks
"maths_marks": request.form.get("maths_marks"),
"science_marks": request.form.get("science_marks"),
"total_marks": request.form.get("total_marks"),
"marks_obtained": request.form.get("marks_obtained"),
"percentage": request.form.get("percentage"),

# ITI Marks
"total_marks_iti": request.form.get("total_marks_iti"),
"marks_obtained_iti": request.form.get("marks_obtained_iti"),
"percentage_iti": request.form.get("percentage_iti"),


            # Admission
            "admission_quota": request.form["admission_quota"],
            "branch": request.form["branch"],
            "password": request.form["password"]
        }

        session.modified = True
        return redirect("/admission/step-2")

    return render_template("admission_step1.html")






@app.route("/admission/step-2", methods=["GET", "POST"])
def admission_step2():
    if "admission" not in session:
        return redirect("/admission/step-1")

    if request.method == "POST":
        session["admission"].update({
            "father_name": request.form["father_name"],
            "father_mobile": request.form["father_mobile"],
            "mother_name": request.form["mother_name"],
            "mother_mobile": request.form["mother_mobile"],
            "residential_address": request.form["residential_address"],
            "permanent_address": request.form["permanent_address"]
        })

        session.modified = True
        return redirect("/admission/step-3")

    return render_template("admission_step2.html")


from datetime import date
import hashlib
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "static/uploads"
ALLOWED_EXTENSIONS = {"pdf", "jpg", "jpeg", "png"}
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


from datetime import date
import hashlib
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "static/uploads"
ALLOWED_EXTENSIONS = {"pdf", "jpg", "jpeg", "png"}
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


from datetime import date
from werkzeug.utils import secure_filename

@app.route("/admission/step-3", methods=["GET", "POST"])
def admission_step3():
    if "admission" not in session:
        return redirect("/admission/step-1")

    admission = session["admission"]
    admission_id = admission["admission_id"]

    if request.method == "POST":

        # ================= ACADEMIC VALIDATION =================
        if admission["qualifying_exam"] in ["SSLC", "PUC"]:
            if not admission.get("maths_marks") or not admission.get("science_marks"):
                return "❌ Maths and Science marks are required"

            if not admission.get("percentage"):
                return "❌ Percentage is required"

        if admission["qualifying_exam"] == "ITI":
            if not admission.get("percentage_iti"):
                return "❌ ITI Percentage is required"

        # ================= AGE VALIDATION =================
        dob = date.fromisoformat(admission["dob"])
        age = (date.today() - dob).days // 365
        if age < 14:
            return "❌ Student must be at least 14 years old"

        # ================= YEAR VALIDATION =================
        year = int(admission["year_of_passing"])
        current_year = date.today().year
        if year > current_year or year < current_year - 10:
            return "❌ Invalid Year of Passing"

        # ================= QUALIFYING EXAM =================
        if admission["qualifying_exam"] not in ["SSLC", "PUC", "ITI"]:
            return "❌ Invalid Qualifying Exam"

        # ================= ITI RULE =================
        if admission["qualifying_exam"] == "ITI" and admission["branch"] == "Computer Engineering":
            return "❌ ITI students are not eligible for Computer Engineering"

        # ================= QUOTA & CATEGORY RULES =================
        if admission["admission_quota"] == "SNQ" and admission["caste_category"] not in ["SC", "ST"]:
            return "❌ SNQ quota is allowed only for SC / ST candidates"

        if admission["allocated_category"] == "GM" and admission["admission_quota"] == "SNQ":
            return "❌ GM category cannot apply under SNQ quota"

        # ================= OPTIONAL FILE UPLOADS =================
        photo = request.files.get("photo")
        marks = request.files.get("marks_card")
        caste = request.files.get("caste_certificate")
        income = request.files.get("income_certificate")

        photo_name = marks_name = caste_name = income_name = None

        def save_file(file, prefix):
            if file and file.filename:
                if not allowed_file(file.filename):
                    return None, "❌ Only PDF / JPG / PNG files are allowed"
                filename = f"{admission_id}_{prefix}_{secure_filename(file.filename)}"
                file.save(os.path.join(UPLOAD_FOLDER, filename))
                return filename, None
            return None, None

        photo_name, err = save_file(photo, "photo")
        if err: return err

        marks_name, err = save_file(marks, "marks")
        if err: return err

        caste_name, err = save_file(caste, "caste")
        if err: return err

        income_name, err = save_file(income, "income")
        if err: return err

        # ================= DATABASE =================
        db = get_db()
        cur = db.cursor()

        cur.execute("""
            INSERT INTO students
            (admission_id, student_name, branch, mobile, password_hash, status)
            VALUES (%s,%s,%s,%s,%s,'INACTIVE')
        """, (
            admission_id,
            admission["student_name"],
            admission["branch"],
            admission["student_mobile"],
            hashlib.sha256(admission["password"].encode()).hexdigest()
        ))

        cur.execute("""
            INSERT INTO student_personal_details
            (
              admission_id,
              dob, gender, nationality, religion,
              caste_category, allocated_category,
              qualifying_exam, year_of_passing, register_number,
              admission_quota,
              father_name, father_mobile,
              mother_name, mother_mobile,
              residential_address, permanent_address,
              photo_file, marks_card_file,
              caste_certificate_file, income_certificate_file
            )
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,
                    %s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            admission_id,
            admission["dob"],
            admission["gender"],
            admission["nationality"],
            admission["religion"],
            admission["caste_category"],
            admission["allocated_category"],
            admission["qualifying_exam"],
            admission["year_of_passing"],
            admission["register_number"],
            admission["admission_quota"],

            admission["father_name"],
            admission["father_mobile"],
            admission["mother_name"],
            admission["mother_mobile"],
            admission["residential_address"],
            admission["permanent_address"],

            photo_name,
            marks_name,
            caste_name,
            income_name
        ))

        db.commit()
        session.pop("admission", None)

        return render_template(
            "admission_success.html",
            admission_id=admission_id
        )

    return render_template("admission_step3.html")



# =========================
# ADMIN: VIEW APPLICATIONS
# =========================
@app.route("/admin/applications")
def admin_applications():
    if "admin" not in session:
        return redirect("/")

    q = request.args.get("q", "")
    status = request.args.get("status", "INACTIVE")

    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("""
        SELECT * FROM students
        WHERE status=%s
        AND (student_name LIKE %s OR admission_id LIKE %s)
    """, (status, f"%{q}%", f"%{q}%"))

    students = cur.fetchall()

    return render_template(
        "admin_applications.html",
        students=students,
        q=q,
        status=status
    )

# =========================
# ADMIN: APPROVE STUDENT
# =========================
@app.route("/approve/<admission_id>")
def approve_student(admission_id):
    if "admin" not in session:
        return redirect("/")

    db = get_db()
    cur = db.cursor()
    cur.execute("""
        UPDATE students
        SET status='ACTIVE'
        WHERE admission_id=%s
    """, (admission_id,))
    db.commit()

    return redirect("/admin/applications")
@app.route("/reject/<admission_id>", methods=["POST"])
def reject_student(admission_id):
    if "admin" not in session:
        return redirect("/")

    reason = request.form["reason"]

    db = get_db()
    cur = db.cursor()
    cur.execute("""
        UPDATE students
        SET status='REJECTED', rejection_reason=%s
        WHERE admission_id=%s
    """, (reason, admission_id))
    db.commit()

    return redirect("/admin/applications")


# =========================
# ADMIN: ADD STUDENT
# =========================
@app.route("/add-student", methods=["GET", "POST"])
def add_student():
    if "admin" not in session:
        return redirect("/")

    if request.method == "POST":
        admission_id = request.form["admission_id"]
        name = request.form["student_name"]
        branch = request.form["branch"]
        year_sem = request.form["year_sem"]
        mobile = request.form["mobile"]
        password = hashlib.sha256(
            request.form["password"].encode()
        ).hexdigest()

        db = get_db()
        cur = db.cursor()
        cur.execute("""
            INSERT INTO students
            (admission_id, student_name, branch, year_sem, mobile, password_hash, status)
            VALUES (%s,%s,%s,%s,%s,%s,'ACTIVE')
        """, (admission_id, name, branch, year_sem, mobile, password))
        db.commit()

        return "✅ Student Added Successfully"

    return render_template("add_student.html")


# =========================
# ADMIN: ADD EDUCATION
# =========================
@app.route("/add-education", methods=["GET", "POST"])
def add_education():
    if "admin" not in session:
        return redirect("/")

    if request.method == "POST":
        data = (
            request.form["admission_id"],
            request.form["qualifying_exam"],
            request.form["register_number"],
            request.form["year_of_passing"],
            request.form["total_max_marks"],
            request.form["total_marks_obtained"],
            request.form["science_max_marks"],
            request.form["science_marks_obtained"],
            request.form["maths_max_marks"],
            request.form["maths_marks_obtained"]
        )

        db = get_db()
        cur = db.cursor()
        cur.execute("""
            INSERT INTO education_details
            (admission_id, qualifying_exam, register_number, year_of_passing,
             total_max_marks, total_marks_obtained,
             science_max_marks, science_marks_obtained,
             maths_max_marks, maths_marks_obtained)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, data)
        db.commit()

        return "✅ Education Details Added"

    return render_template("add_education.html")


# =========================
# ADMIN: SET FEES
# =========================
@app.route("/admin/fees", methods=["GET", "POST"])
def admin_fees():
    if "admin" not in session:
        return redirect("/")

    if request.method == "POST":
        admission_id = request.form["admission_id"]
        admission_fee = request.form["admission_fee"]
        tuition_fee = request.form["tuition_fee"]
        exam_fee = request.form["exam_fee"]
        status = request.form["payment_status"]

        db = get_db()
        cur = db.cursor()

        cur.execute(
            "SELECT * FROM fees WHERE admission_id=%s",
            (admission_id,)
        )

        if cur.fetchone():
            cur.execute("""
                UPDATE fees
                SET admission_fee=%s,
                    tuition_fee=%s,
                    exam_fee=%s,
                    payment_status=%s
                WHERE admission_id=%s
            """, (admission_fee, tuition_fee, exam_fee, status, admission_id))
        else:
            cur.execute("""
                INSERT INTO fees
                (admission_id, admission_fee, tuition_fee, exam_fee, payment_status)
                VALUES (%s,%s,%s,%s,%s)
            """, (admission_id, admission_fee, tuition_fee, exam_fee, status))

        db.commit()
        return "✅ Fees Updated Successfully"

    return render_template("admin_fees.html")


# =========================
# STUDENT DASHBOARD
# =========================
@app.route("/student")
def student_dashboard():
    if "student" not in session:
        return redirect("/")

    admission_id = session["student"]

    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("SELECT * FROM students WHERE admission_id=%s", (admission_id,))
    student = cur.fetchone()

    cur.execute("SELECT * FROM education_details WHERE admission_id=%s", (admission_id,))
    education = cur.fetchone()

    cur.execute("SELECT * FROM fees WHERE admission_id=%s", (admission_id,))
    fees = cur.fetchone()

    return render_template(
        "student_dashboard.html",
        student=student,
        education=education,
        fees=fees
    )


# =========================
# PDF: ADMISSION LETTER
# =========================
@app.route("/student/admission-letter")
def admission_letter():
    if "student" not in session:
        return redirect("/")

    admission_id = session["student"]
    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("SELECT * FROM students WHERE admission_id=%s", (admission_id,))
    student = cur.fetchone()

    pdf = generate_admission_letter(student)
    return send_file(pdf, as_attachment=True)


# =========================
# PDF: FEE RECEIPT
# =========================
@app.route("/student/fee-receipt")
def fee_receipt():
    if "student" not in session:
        return redirect("/")

    admission_id = session["student"]
    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("SELECT * FROM students WHERE admission_id=%s", (admission_id,))
    student = cur.fetchone()

    cur.execute("SELECT * FROM fees WHERE admission_id=%s", (admission_id,))
    fees = cur.fetchone()

    pdf = generate_fee_receipt(student, fees)
    return send_file(pdf, as_attachment=True)
@app.route("/admin/student/<admission_id>")
def admin_view_student(admission_id):
    if "admin" not in session:
        return redirect("/")

    db = get_db()
    cur = db.cursor(dictionary=True)

    cur.execute("SELECT * FROM students WHERE admission_id=%s", (admission_id,))
    student = cur.fetchone()

    cur.execute("""
        SELECT * FROM student_personal_details
        WHERE admission_id=%s
    """, (admission_id,))
    personal = cur.fetchone()

    return render_template(
        "admin_view_student.html",
        student=student,
        personal=personal
    )

import zipfile
from io import BytesIO

@app.route("/admin/download-all/<admission_id>")
def download_all_docs(admission_id):
    if "admin" not in session:
        return redirect("/")

    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT * FROM student_personal_details
        WHERE admission_id=%s
    """, (admission_id,))
    p = cur.fetchone()

    zip_buffer = BytesIO()
    with zipfile.ZipFile(zip_buffer, "w") as z:
        for f in [
            p["photo_file"],
            p["marks_card_file"],
            p["caste_certificate_file"],
            p["income_certificate_file"]
        ]:
            z.write(f"static/uploads/{f}", f)

    zip_buffer.seek(0)

    return send_file(
        zip_buffer,
        as_attachment=True,
        download_name=f"{admission_id}_documents.zip"
    )

@app.route("/student/reupload", methods=["GET", "POST"])
def student_reupload():
    if "student" not in session:
        return redirect("/login")

    admission_id = session["student"]

    if request.method == "POST":

        photo = request.files.get("photo")
        marks = request.files.get("marks_card")
        caste = request.files.get("caste_certificate")
        income = request.files.get("income_certificate")

        def save_file(file, prefix):
            if file and file.filename:
                if not allowed_file(file.filename):
                    return None, "❌ Invalid file type"
                name = f"{admission_id}_{prefix}_{secure_filename(file.filename)}"
                file.save(os.path.join(UPLOAD_FOLDER, name))
                return name, None
            return None, None

        photo_name, err = save_file(photo, "photo")
        if err: return err

        marks_name, err = save_file(marks, "marks")
        if err: return err

        caste_name, err = save_file(caste, "caste")
        if err: return err

        income_name, err = save_file(income, "income")
        if err: return err

        db = get_db()
        cur = db.cursor()

        # 🔁 UPDATE ONLY UPLOADED FILES
        if photo_name:
            cur.execute(
                "UPDATE student_personal_details SET photo_file=%s WHERE admission_id=%s",
                (photo_name, admission_id)
            )
        if marks_name:
            cur.execute(
                "UPDATE student_personal_details SET marks_card_file=%s WHERE admission_id=%s",
                (marks_name, admission_id)
            )
        if caste_name:
            cur.execute(
                "UPDATE student_personal_details SET caste_certificate_file=%s WHERE admission_id=%s",
                (caste_name, admission_id)
            )
        if income_name:
            cur.execute(
                "UPDATE student_personal_details SET income_certificate_file=%s WHERE admission_id=%s",
                (income_name, admission_id)
            )

        # 🔁 RESET STATUS FOR REVIEW
        cur.execute("""
            UPDATE students
            SET status='INACTIVE', rejection_reason=NULL
            WHERE admission_id=%s
        """, (admission_id,))

        db.commit()

        return """
        <h3>✅ Documents Re-uploaded Successfully</h3>
        <p>Your application is sent back for admin review.</p>
        <a href="/login">Back to Login</a>
        """

    return render_template("student_reupload.html")

# =========================
# RUN SERVER
# =========================
if __name__ == "__main__":
    app.run(debug=True)

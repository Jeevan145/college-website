from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.lib import colors


def generate_admission_letter(student):
    file_path = f"static/pdfs/admission_{student['admission_id']}.pdf"

    doc = SimpleDocTemplate(file_path, pagesize=A4)
    styles = getSampleStyleSheet()
    elements = []

    elements.append(Paragraph("<b>Sri Venkateshwara Polytechnic</b>", styles["Title"]))
    elements.append(Spacer(1, 20))
    elements.append(Paragraph("ADMISSION LETTER", styles["Heading2"]))
    elements.append(Spacer(1, 20))

    text = f"""
    This is to certify that <b>{student['student_name']}</b> has been admitted to
    <b>{student['branch']}</b> for the academic year 2026–27.
    <br/><br/>
    Admission ID: <b>{student['admission_id']}</b>
    """

    elements.append(Paragraph(text, styles["Normal"]))
    elements.append(Spacer(1, 40))
    elements.append(Paragraph("Principal<br/>Sri Venkateshwara Polytechnic", styles["Normal"]))

    doc.build(elements)
    return file_path


def generate_fee_receipt(student, fees):
    file_path = f"static/pdfs/fee_receipt_{student['admission_id']}.pdf"

    doc = SimpleDocTemplate(file_path, pagesize=A4)
    styles = getSampleStyleSheet()
    elements = []

    elements.append(Paragraph("<b>Sri Venkateshwara Polytechnic</b>", styles["Title"]))
    elements.append(Spacer(1, 20))
    elements.append(Paragraph("FEE RECEIPT", styles["Heading2"]))
    elements.append(Spacer(1, 20))

    data = [
        ["Admission ID", student["admission_id"]],
        ["Student Name", student["student_name"]],
        ["Branch", student["branch"]],
        ["Admission Fee", f"₹ {fees['admission_fee']}"],
        ["Tuition Fee", f"₹ {fees['tuition_fee']}"],
        ["Exam Fee", f"₹ {fees['exam_fee']}"],
        ["Payment Status", fees["payment_status"]],
    ]

    table = Table(data, colWidths=[6*cm, 8*cm])
    table.setStyle([
        ("GRID", (0,0), (-1,-1), 1, colors.black),
        ("BACKGROUND", (0,0), (-1,0), colors.lightgrey),
    ])

    elements.append(table)
    doc.build(elements)

    return file_path

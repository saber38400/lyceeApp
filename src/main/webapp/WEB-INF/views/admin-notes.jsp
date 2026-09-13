<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gestion des notes</title>

<style>
body{ margin:0; font-family:Arial, Helvetica, sans-serif; background:#f2f2f2; }
.header{ background:#4a69bd; color:white; padding:30px; text-align:center; position:relative; }
.container{ width:90%; max-width:800px; margin:auto; margin-top:20px; }
.card{ background:white; padding:20px; margin-bottom:20px; border-radius:10px; box-shadow:0px 0px 10px rgba(0,0,0,0.1); }
.menu{ display:flex; gap:20px; justify-content:center; margin-top:15px; }
.menu a{ text-decoration:none; color:white; font-weight:bold; }
.datetime{ position:absolute; top:20px; right:30px; color:white; text-align:right; font-size:14px; font-weight:bold; }
.formGroup{ margin-bottom:15px; }
.formGroup label{ display:block; margin-bottom:5px; font-weight:bold; font-size:14px; color:#555; }
.formGroup input{ width:100%; padding:10px; border:1px solid #ccc; border-radius:6px; box-sizing:border-box; }
.saveButton{ background:#4a69bd; color:white; border:none; padding:10px 20px; border-radius:6px; cursor:pointer; font-weight:bold; }
.cancelButton{ background:#ccc; color:#333; border:none; padding:10px 20px; border-radius:6px; cursor:pointer; font-weight:bold; margin-left:10px; }
.adminTable{ width:100%; border-collapse:collapse; }
.adminTable th, .adminTable td{ text-align:left; padding:10px; border-bottom:1px solid #eee; }
.adminTable th{ color:#888; font-size:13px; text-transform:uppercase; }
.actionLink{ color:#4a69bd; cursor:pointer; margin-right:10px; font-size:13px; }
.deleteLink{ color:#e74c3c; cursor:pointer; font-size:13px; }
</style>
</head>
<body>

<div class="header">
    <div class="datetime"><div id="date"></div><div id="clock"></div></div>
    <h1>Notes de ${studentEmail}</h1>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin">← Retour à l'espace admin</a>
    </div>
</div>

<div class="container">

    <div class="card">

        <h2 id="formTitle">Ajouter une note</h2>

        <form action="${pageContext.request.contextPath}/admin/notes/save" method="post" id="noteForm">

            <input type="hidden" name="id" id="noteId" value="">
            <input type="hidden" name="studentEmail" value="${studentEmail}">

            <div class="formGroup">
                <label>Matière</label>
                <input type="text" name="subject" id="noteSubject" required>
            </div>

            <div class="formGroup">
                <label>Note obtenue</label>
                <input type="number" step="0.5" name="noteValue" id="noteValueField" required>
            </div>

            <div class="formGroup">
                <label>Barème (sur combien)</label>
                <input type="number" step="0.5" name="maxValue" id="noteMaxValue" value="20" required>
            </div>

            <div class="formGroup">
                <label>Date</label>
                <input type="date" name="dateNote" id="noteDate" required>
            </div>

            <button type="submit" class="saveButton">Enregistrer</button>
            <button type="button" class="cancelButton" onclick="resetForm()">Annuler</button>

        </form>

    </div>

    <div class="card">

        <h2>Notes existantes</h2>

        <c:if test="${empty notes}">
            <p>Aucune note pour cet élève.</p>
        </c:if>

        <c:if test="${not empty notes}">

            <table class="adminTable">
                <tr>
                    <th>Matière</th>
                    <th>Note</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>

                <c:forEach var="note" items="${notes}">
                    <tr>
                        <td>${note.subject}</td>
                        <td>${note.noteValue} / ${note.maxValue}</td>
                        <td>${note.dateNote}</td>
                        <td>
                            <span class="actionLink" onclick="editNote(${note.id}, '${note.subject}', ${note.noteValue}, ${note.maxValue}, '${note.dateNote}')">Modifier</span>
                            <a class="deleteLink" href="${pageContext.request.contextPath}/admin/notes/${studentEmail}/delete/${note.id}" onclick="return confirm('Supprimer cette note ?');">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>

            </table>

        </c:if>

    </div>

</div>

<script>
function updateDateTime(){
    const now = new Date();
    document.getElementById("date").innerHTML = now.toLocaleDateString('fr-FR', { weekday:'long', year:'numeric', month:'long', day:'numeric' });
    document.getElementById("clock").innerHTML = now.toLocaleTimeString('fr-FR');
}
window.addEventListener("DOMContentLoaded", function(){ updateDateTime(); setInterval(updateDateTime, 1000); });

function editNote(id, subject, noteValue, maxValue, dateNote) {
    document.getElementById("formTitle").textContent = "Modifier la note";
    document.getElementById("noteId").value = id;
    document.getElementById("noteSubject").value = subject;
    document.getElementById("noteValueField").value = noteValue;
    document.getElementById("noteMaxValue").value = maxValue;
    document.getElementById("noteDate").value = dateNote;
    window.scrollTo(0, 0);
}

function resetForm() {
    document.getElementById("formTitle").textContent = "Ajouter une note";
    document.getElementById("noteForm").reset();
    document.getElementById("noteId").value = "";
    document.getElementById("noteMaxValue").value = "20";
}
</script>

</body>
</html>
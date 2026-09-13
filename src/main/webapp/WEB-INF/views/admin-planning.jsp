<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gestion de l'emploi du temps</title>

<style>
body{ margin:0; font-family:Arial, Helvetica, sans-serif; background:#f2f2f2; }
.header{ background:#4a69bd; color:white; padding:30px; text-align:center; position:relative; }
.container{ width:90%; max-width:900px; margin:auto; margin-top:20px; }
.card{ background:white; padding:20px; margin-bottom:20px; border-radius:10px; box-shadow:0px 0px 10px rgba(0,0,0,0.1); }
.menu{ display:flex; gap:20px; justify-content:center; margin-top:15px; }
.menu a{ text-decoration:none; color:white; font-weight:bold; }
.datetime{ position:absolute; top:20px; right:30px; color:white; text-align:right; font-size:14px; font-weight:bold; }
.formGroup{ margin-bottom:15px; }
.formGroup label{ display:block; margin-bottom:5px; font-weight:bold; font-size:14px; color:#555; }
.formGroup input, .formGroup select{ width:100%; padding:10px; border:1px solid #ccc; border-radius:6px; box-sizing:border-box; }
.saveButton{ background:#4a69bd; color:white; border:none; padding:10px 20px; border-radius:6px; cursor:pointer; font-weight:bold; }
.cancelButton{ background:#ccc; color:#333; border:none; padding:10px 20px; border-radius:6px; cursor:pointer; font-weight:bold; margin-left:10px; }
.checkboxRow{ display:flex; align-items:center; gap:8px; margin-bottom:15px; }
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
    <h1>Emploi du temps - Gestion</h1>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin">← Retour à l'espace admin</a>
    </div>
</div>

<div class="container">

    <div class="card">

        <h2 id="formTitle">Ajouter un créneau</h2>

        <form action="${pageContext.request.contextPath}/admin/planning/save" method="post" id="slotForm">

            <input type="hidden" name="id" id="slotId" value="">

            <div class="formGroup">
                <label>Jour</label>
                <select name="dayOfWeek" id="slotDay" required>
                    <option value="Lundi">Lundi</option>
                    <option value="Mardi">Mardi</option>
                    <option value="Mercredi">Mercredi</option>
                    <option value="Jeudi">Jeudi</option>
                    <option value="Vendredi">Vendredi</option>
                </select>
            </div>

            <div class="formGroup">
                <label>Heure de début</label>
                <input type="time" name="startTime" id="slotStart" required>
            </div>

            <div class="formGroup">
                <label>Heure de fin</label>
                <input type="time" name="endTime" id="slotEnd" required>
            </div>

            <div class="formGroup">
                <label>Matière</label>
                <input type="text" name="subject" id="slotSubject" required>
            </div>

            <div class="checkboxRow">
                <input type="checkbox" name="lunchBreak" id="slotLunch" value="true">
                <label style="margin:0;">C'est la pause déjeuner</label>
            </div>

            <button type="submit" class="saveButton">Enregistrer</button>
            <button type="button" class="cancelButton" onclick="resetForm()">Annuler</button>

        </form>

    </div>

    <div class="card">

        <h2>Créneaux existants</h2>

        <c:if test="${empty slots}">
            <p>Aucun créneau pour le moment.</p>
        </c:if>

        <c:if test="${not empty slots}">

            <table class="adminTable">
                <tr>
                    <th>Jour</th>
                    <th>Horaire</th>
                    <th>Matière</th>
                    <th>Actions</th>
                </tr>

                <c:forEach var="slot" items="${slots}">
                    <tr>
                        <td>${slot.dayOfWeek}</td>
                        <td>${slot.startTime} - ${slot.endTime}</td>
                        <td>${slot.subject}</td>
                        <td>
                            <span class="actionLink" onclick="editSlot(${slot.id}, '${slot.dayOfWeek}', '${slot.startTime}', '${slot.endTime}', '${slot.subject}', ${slot.lunchBreak})">Modifier</span>
                            <a class="deleteLink" href="${pageContext.request.contextPath}/admin/planning/delete/${slot.id}" onclick="return confirm('Supprimer ce créneau ?');">Supprimer</a>
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

function editSlot(id, day, start, end, subject, lunch) {
    document.getElementById("formTitle").textContent = "Modifier le créneau";
    document.getElementById("slotId").value = id;
    document.getElementById("slotDay").value = day;
    document.getElementById("slotStart").value = start;
    document.getElementById("slotEnd").value = end;
    document.getElementById("slotSubject").value = subject;
    document.getElementById("slotLunch").checked = lunch;
    window.scrollTo(0, 0);
}

function resetForm() {
    document.getElementById("formTitle").textContent = "Ajouter un créneau";
    document.getElementById("slotForm").reset();
    document.getElementById("slotId").value = "";
}
</script>

</body>
</html>
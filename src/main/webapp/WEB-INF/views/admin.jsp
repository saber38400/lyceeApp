<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Espace Admin</title>

<style>
body{ margin:0; font-family:Arial, Helvetica, sans-serif; background:#f2f2f2; }
.header{ background:#4a69bd; color:white; padding:30px; text-align:center; position:relative; }
.container{ width:90%; margin:auto; margin-top:20px; }
.card{ background:white; padding:20px; margin-bottom:20px; border-radius:10px; box-shadow:0px 0px 10px rgba(0,0,0,0.1); }
.menu{ display:flex; gap:20px; justify-content:center; margin-top:15px; }
.menu a{ text-decoration:none; color:white; font-weight:bold; }
.unreadBadge{ background:#e74c3c; color:white; border-radius:50%; padding:2px 7px; font-size:12px; margin-left:6px; }
.notifPopup{ position:fixed; top:20px; right:20px; background:#333; color:white; padding:15px 20px; border-radius:8px; box-shadow:0px 2px 10px rgba(0,0,0,0.3); z-index:9999; max-width:300px; animation:fadeInNotif 0.3s ease; }
@keyframes fadeInNotif{ from{ opacity:0; transform:translateY(-10px); } to{ opacity:1; transform:translateY(0); } }
.datetime{ position:absolute; top:20px; right:30px; color:white; text-align:right; font-size:14px; font-weight:bold; }
.adminTable{ width:100%; border-collapse:collapse; }
.adminTable th, .adminTable td{ text-align:left; padding:10px; border-bottom:1px solid #eee; }
.adminTable th{ color:#888; font-size:13px; text-transform:uppercase; }
.actionBtn{ background:#4a69bd; color:white; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; text-decoration:none; font-size:13px; margin-right:5px; display:inline-block; }
.adminBadgeTag{ background:#2ecc71; color:white; padding:3px 8px; border-radius:6px; font-size:12px; }
</style>
</head>
<body>

<div class="header">
    <div class="datetime"><div id="date"></div><div id="clock"></div></div>
    <h1>Espace Admin</h1>
    <p>Bienvenue ${sessionScope.username}</p>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/dummy">Accueil</a>
        <a href="${pageContext.request.contextPath}/messages">
            Messagerie
            <span class="unreadBadge" style="${unreadCount > 0 ? '' : 'display:none;'}">${unreadCount}</span>
        </a>
        <a href="${pageContext.request.contextPath}/notes">Notes</a>
        <a href="${pageContext.request.contextPath}/emploi-du-temps">Emploi du temps</a>
        <a href="${pageContext.request.contextPath}/profil">Espace personnel</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>

<div class="container">

    <div class="card">
        <h2>Emploi du temps de la classe</h2>
        <a href="${pageContext.request.contextPath}/admin/planning" class="actionBtn">Gérer le planning</a>
    </div>

    <div class="card">
        <h2>Élèves</h2>

        <table class="adminTable">
            <tr>
                <th>Nom</th>
                <th>Email</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>

            <c:forEach var="s" items="${students}">
                <tr>
                    <td>${s.user_fname} ${s.user_lname}</td>
                    <td>${s.user_email}</td>
                    <td>
                        <c:choose>
                            <c:when test="${s.admin}"><span class="adminBadgeTag">Admin</span></c:when>
                            <c:otherwise>Élève</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/notes/${s.user_email}" class="actionBtn">Gérer les notes</a>
                        <c:if test="${!s.admin}">
                            <a href="${pageContext.request.contextPath}/admin/promote/${s.user_email}" class="actionBtn" style="background:#e67e22;" onclick="return confirm('Passer ${s.user_fname} en compte admin ?');">Promouvoir admin</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>

        </table>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
function updateDateTime(){
    const now = new Date();
    document.getElementById("date").innerHTML = now.toLocaleDateString('fr-FR', { weekday:'long', year:'numeric', month:'long', day:'numeric' });
    document.getElementById("clock").innerHTML = now.toLocaleTimeString('fr-FR');
}
window.addEventListener("DOMContentLoaded", function(){ updateDateTime(); setInterval(updateDateTime, 1000); });

let notifSocket = new SockJS("${pageContext.request.contextPath}/chat");
let notifStomp = Stomp.over(notifSocket);
const myUsername = "${sessionScope.username}";

notifStomp.connect({}, function(){
    notifStomp.subscribe("/topic/messages/" + myUsername, function(frame){
        const message = JSON.parse(frame.body);
        showNotificationPopup(message.sender, message.content || "📎 Fichier envoyé");
        incrementUnreadBadge();
    });
});

function showNotificationPopup(sender, content){
    const popup = document.createElement("div");
    popup.className = "notifPopup";
    popup.innerHTML = "<strong>" + sender + "</strong><br>" + content;
    document.body.appendChild(popup);
    setTimeout(function(){ popup.remove(); }, 4000);
}

function incrementUnreadBadge(){
    document.querySelectorAll(".unreadBadge").forEach(function(badge){
        let current = parseInt(badge.textContent) || 0;
        current = current + 1;
        badge.textContent = current;
        badge.style.display = "inline-block";
    });
}
</script>

</body>
</html>
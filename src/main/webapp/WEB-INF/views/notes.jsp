<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Mes Notes</title>

<style>

body{
    margin:0;
    font-family:Arial, Helvetica, sans-serif;
    background:#f2f2f2;
}

.header{
    background:#4a69bd;
    color:white;
    padding:30px;
    text-align:center;
    position:relative;
}

.container{
    width:90%;
    margin:auto;
    margin-top:20px;
}

.card{
    background:white;
    padding:20px;
    margin-bottom:20px;
    border-radius:10px;
    box-shadow:0px 0px 10px rgba(0,0,0,0.1);
}

.menu{
    display:flex;
    gap:20px;
    margin-top:15px;
    justify-content:center;
}

.menu a{
    text-decoration:none;
    color:white;
    font-weight:bold;
}

.unreadBadge{
    background:#e74c3c;
    color:white;
    border-radius:50%;
    padding:2px 7px;
    font-size:12px;
    margin-left:6px;
}

.notifPopup{
    position:fixed;
    top:20px;
    right:20px;
    background:#333;
    color:white;
    padding:15px 20px;
    border-radius:8px;
    box-shadow:0px 2px 10px rgba(0,0,0,0.3);
    z-index:9999;
    max-width:300px;
    animation:fadeInNotif 0.3s ease;
}

@keyframes fadeInNotif{
    from{ opacity:0; transform:translateY(-10px); }
    to{ opacity:1; transform:translateY(0); }
}

.datetime{
    position:absolute;
    top:20px;
    right:30px;
    color:white;
    text-align:right;
    font-size:14px;
    font-weight:bold;
}

.averageValue{
    font-size:40px;
    font-weight:bold;
    color:#4a69bd;
    text-align:center;
    padding:10px 0;
}

.notesTable{
    width:100%;
    border-collapse:collapse;
}

.notesTable th, .notesTable td{
    text-align:left;
    padding:10px;
    border-bottom:1px solid #eee;
}

.notesTable th{
    color:#888;
    font-size:13px;
    text-transform:uppercase;
}

</style>

</head>

<body>

<div class="header">

    <div class="datetime">
        <div id="date"></div>
        <div id="clock"></div>
    </div>

    <h1>Mes Notes</h1>

    <p>Bienvenue ${sessionScope.username}</p>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/dummy">Accueil</a>

        <a href="${pageContext.request.contextPath}/messages">
            Messagerie
            <span class="unreadBadge"
                  style="${unreadCount > 0 ? '' : 'display:none;'}">${unreadCount}</span>
        </a>

        <a href="#">Emploi du temps</a>

        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>

</div>

<div class="container">

    <div class="card">

        <h2>Moyenne générale</h2>

        <div class="averageValue">${average} / 20</div>

    </div>

    <div class="card">

        <h2>Détail des notes</h2>

        <c:if test="${empty notes}">
            <p>Aucune note pour le moment.</p>
        </c:if>

        <c:if test="${not empty notes}">

            <table class="notesTable">

                <tr>
                    <th>Matière</th>
                    <th>Note</th>
                    <th>Date</th>
                </tr>

                <c:forEach var="note" items="${notes}">
                    <tr>
                        <td>${note.subject}</td>
                        <td>${note.noteValue} / ${note.maxValue}</td>
                        <td>${note.dateNote}</td>
                    </tr>
                </c:forEach>

            </table>

        </c:if>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>

function updateDateTime()
{
    const now = new Date();

    const date = now.toLocaleDateString('fr-FR', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });

    const time = now.toLocaleTimeString('fr-FR');

    document.getElementById("date").innerHTML = date;
    document.getElementById("clock").innerHTML = time;
}

window.addEventListener("DOMContentLoaded", function() {
    updateDateTime();
    setInterval(updateDateTime, 1000);
});

let notifSocket =
    new SockJS("${pageContext.request.contextPath}/chat");

let notifStomp =
    Stomp.over(notifSocket);

const myUsername = "${sessionScope.username}";

notifStomp.connect({}, function() {

    notifStomp.subscribe(
        "/topic/messages/" + myUsername,

        function(frame) {

            const message = JSON.parse(frame.body);

            showNotificationPopup(message.sender, message.content || "📎 Fichier envoyé");
            incrementUnreadBadge();

        });

});

function showNotificationPopup(sender, content) {

    const popup = document.createElement("div");
    popup.className = "notifPopup";
    popup.innerHTML =
        "<strong>" + sender + "</strong><br>" + content;

    document.body.appendChild(popup);

    setTimeout(function() {
        popup.remove();
    }, 4000);
}

function incrementUnreadBadge() {

    document.querySelectorAll(".unreadBadge").forEach(function(badge) {

        let current = parseInt(badge.textContent) || 0;
        current = current + 1;

        badge.textContent = current;
        badge.style.display = "inline-block";

    });
}

</script>

</body>
</html>
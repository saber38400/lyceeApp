<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Espace personnel</title>

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
    max-width:700px;
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
    justify-content:center;
    margin-top:15px;
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

.profilePhotoBig{
    width:110px;
    height:110px;
    border-radius:50%;
    object-fit:cover;
    display:block;
    margin:0 auto 15px auto;
}

.avatarBig{
    width:110px;
    height:110px;
    border-radius:50%;
    background:#4a69bd;
    color:white;
    display:flex;
    justify-content:center;
    align-items:center;
    font-size:40px;
    margin:0 auto 15px auto;
}

.formGroup{
    margin-bottom:15px;
}

.formGroup label{
    display:block;
    margin-bottom:5px;
    font-weight:bold;
    font-size:14px;
    color:#555;
}

.formGroup input{
    width:100%;
    padding:10px;
    border:1px solid #ccc;
    border-radius:6px;
    box-sizing:border-box;
}

.saveButton{
    background:#4a69bd;
    color:white;
    border:none;
    padding:10px 20px;
    border-radius:6px;
    cursor:pointer;
    font-weight:bold;
}

.formMessage{
    padding:10px;
    border-radius:6px;
    margin-bottom:15px;
    background:#eef6ec;
    color:#2d6a2d;
    font-size:14px;
}

.cardHeader{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:10px;
}

.editPencil{
    cursor:pointer;
    font-size:18px;
    background:#f0f0f0;
    border-radius:6px;
    padding:5px 10px;
    user-select:none;
}

.editPencil:hover{
    background:#e0e0e0;
}

.viewRow{
    margin-bottom:10px;
    font-size:15px;
}

.viewRow span.label{
    color:#888;
    font-size:13px;
    display:block;
}

.hidden{
    display:none;
}

.passwordDots{
    font-size:20px;
    letter-spacing:3px;
    color:#555;
}

</style>

</head>

<body>

<div class="header">

    <div class="datetime">
        <div id="date"></div>
        <div id="clock"></div>
    </div>

    <h1>Espace personnel</h1>

    <p>Bienvenue ${sessionScope.username}</p>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/dummy">Accueil</a>

        <a href="${pageContext.request.contextPath}/messages">
            Messagerie
            <span class="unreadBadge"
                  style="${unreadCount > 0 ? '' : 'display:none;'}">${unreadCount}</span>
        </a>

        <a href="${pageContext.request.contextPath}/notes">Notes</a>

        <a href="${pageContext.request.contextPath}/emploi-du-temps">Emploi du temps</a>

        <c:if test="${sessionScope.isAdmin}">
            <a href="${pageContext.request.contextPath}/admin">Admin</a>
        </c:if>

        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>

</div>

<div class="container">

    <div class="card">

        <div class="cardHeader">
            <h2 style="margin:0;">Photo de profil</h2>
            <span class="editPencil" onclick="toggleEdit('Photo')">✏️</span>
        </div>

        <div id="viewPhoto">

            <c:choose>
                <c:when test="${not empty user.user_photo}">
                    <img src="${pageContext.request.contextPath}/uploads/${user.user_photo}" class="profilePhotoBig" alt="photo de profil">
                </c:when>
                <c:otherwise>
                    <div class="avatarBig">${user.user_fname.substring(0,1)}</div>
                </c:otherwise>
            </c:choose>

        </div>

        <div id="editPhoto" class="hidden">

            <c:choose>
                <c:when test="${not empty user.user_photo}">
                    <img src="${pageContext.request.contextPath}/uploads/${user.user_photo}" class="profilePhotoBig" alt="photo de profil">
                </c:when>
                <c:otherwise>
                    <div class="avatarBig">${user.user_fname.substring(0,1)}</div>
                </c:otherwise>
            </c:choose>

            <form action="${pageContext.request.contextPath}/profil/updatePhoto"
                  method="post"
                  enctype="multipart/form-data"
                  style="text-align:center;">

                <input type="file" name="photo" accept="image/*" required>
                <br><br>
                <button type="submit" class="saveButton">Changer la photo</button>

            </form>

        </div>

    </div>

    <div class="card">

        <div class="cardHeader">
            <h2 style="margin:0;">Informations personnelles</h2>
            <span class="editPencil" onclick="toggleEdit('Info')">✏️</span>
        </div>

        <div id="viewInfo">

            <div class="viewRow">
                <span class="label">Prénom</span>
                ${user.user_fname}
            </div>

            <div class="viewRow">
                <span class="label">Nom</span>
                ${user.user_lname}
            </div>

            <div class="viewRow">
                <span class="label">Date de naissance</span>
                <c:choose>
                    <c:when test="${not empty user.user_birthdate}">${user.user_birthdate}</c:when>
                    <c:otherwise>Non renseignée</c:otherwise>
                </c:choose>
            </div>

            <div class="viewRow">
                <span class="label">Classe</span>
                <c:choose>
                    <c:when test="${not empty user.user_classe}">${user.user_classe}</c:when>
                    <c:otherwise>Non renseignée</c:otherwise>
                </c:choose>
            </div>

        </div>

        <div id="editInfo" class="hidden">

            <form action="${pageContext.request.contextPath}/profil/updateInfo" method="post">

                <div class="formGroup">
                    <label>Prénom</label>
                    <input type="text" name="user_fname" value="${user.user_fname}" required>
                </div>

                <div class="formGroup">
                    <label>Nom</label>
                    <input type="text" name="user_lname" value="${user.user_lname}" required>
                </div>

                <div class="formGroup">
                    <label>Date de naissance</label>
                    <input type="date" name="user_birthdate" value="${user.user_birthdate}">
                </div>

                <div class="formGroup">
                    <label>Classe</label>
                    <input type="text" name="user_classe" value="${user.user_classe}" placeholder="Ex: Terminale G1">
                </div>

                <button type="submit" class="saveButton">Enregistrer</button>

            </form>

        </div>

    </div>

    <div class="card">

        <div class="cardHeader">
            <h2 style="margin:0;">Mot de passe</h2>
            <span class="editPencil" onclick="toggleEdit('Password')">✏️</span>
        </div>

        <c:if test="${not empty passwordMessage}">
            <div class="formMessage">${passwordMessage}</div>
        </c:if>

        <div id="viewPassword">
            <div class="passwordDots">••••••••</div>
        </div>

        <div id="editPassword" class="hidden">

            <form action="${pageContext.request.contextPath}/profil/updatePassword" method="post">

                <div class="formGroup">
                    <label>Mot de passe actuel</label>
                    <input type="password" name="currentPassword" required>
                </div>

                <div class="formGroup">
                    <label>Nouveau mot de passe</label>
                    <input type="password" name="newPassword" required>
                </div>

                <button type="submit" class="saveButton">Changer le mot de passe</button>

            </form>

        </div>

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

function toggleEdit(section) {

    const viewDiv = document.getElementById("view" + section);
    const editDiv = document.getElementById("edit" + section);

    if(editDiv.classList.contains("hidden")) {
        viewDiv.classList.add("hidden");
        editDiv.classList.remove("hidden");
    } else {
        viewDiv.classList.remove("hidden");
        editDiv.classList.add("hidden");
    }

}

</script>

</body>
</html>
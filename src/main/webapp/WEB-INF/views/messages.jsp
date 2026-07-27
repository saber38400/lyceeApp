<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
uri="jakarta.tags.core"%>

<%@ taglib prefix="fn"
uri="jakarta.tags.functions"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Messagerie</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, Helvetica, sans-serif;
}

body{
    background:#edf2f7;
}

.header{
    background:#4a69bd;
    color:white;
    padding:20px;
    position:relative;
}

.header h1{
    margin-bottom:10px;
}

.menu{
    display:flex;
    gap:20px;
}

.menu a{
    color:white;
    text-decoration:none;
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

.typingIndicator{
    padding:8px 20px;
    font-style:italic;
    font-size:13px;
    color:#888;
    display:none;
}

.statusIndicator{
    font-size:11px;
    color:#4a69bd;
    text-align:right;
    margin-top:2px;
}

@keyframes fadeInNotif{
    from{ opacity:0; transform:translateY(-10px); }
    to{ opacity:1; transform:translateY(0); }
}

.container{
    display:flex;
    height:calc(100vh - 90px);
}

.leftPanel{
    width:320px;
    background:white;
    border-right:1px solid #ddd;
    overflow-y:auto;
}

.search{
    padding:15px;
    border-bottom:1px solid #ddd;
    box-sizing:border-box;
}

.search input{
    width:100%;
    box-sizing:border-box;
    padding:10px;
    border:1px solid #ddd;
    border-radius:6px;
    font-size:14px;
}

.userCard{
    display:flex;
    align-items:center;
    padding:15px;
    cursor:pointer;
    transition:0.2s;
}

.userCard:hover{
    background:#f5f5f5;
}

.avatar{
    width:55px;
    height:55px;
    border-radius:50%;
    background:#4a69bd;
    color:white;
    display:flex;
    justify-content:center;
    align-items:center;
    font-size:20px;
    margin-right:15px;
}

.avatarImg{
    width:55px;
    height:55px;
    border-radius:50%;
    object-fit:cover;
    margin-right:15px;
}

.avatarImgSmall{
    width:32px;
    height:32px;
    border-radius:50%;
    object-fit:cover;
    margin-right:10px;
}

.chatHeaderContent{
    display:flex;
    align-items:center;
}

.userInfo{
    flex:1;
}

.userName{
    font-weight:bold;
}

.lastMessage{
    color:gray;
    font-size:13px;
}

.rightPanel{
    flex:1;
    display:flex;
    flex-direction:column;
}

.chatHeader{
    background:white;
    padding:20px;
    border-bottom:1px solid #ddd;
    font-weight:bold;
    font-size:20px;
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

.messages{
    flex:1;
    overflow-y:auto;
    padding:20px;
    background:#e5ddd5;
}

.messageMine{
    display:flex;
    flex-direction:column;
    align-items:flex-end;
    margin-bottom:15px;
}

.messageOther{
    display:flex;
    flex-direction:column;
    align-items:flex-start;
    margin-bottom:15px;
}

.bubbleMine{
    background:#4a69bd;
    color:white;
    padding:12px 18px;
    border-radius:20px;
    max-width:60%;
}

.bubbleOther{
    background:white;
    padding:12px 18px;
    border-radius:20px;
    max-width:60%;
}

.sendBox{
    background:white;
    padding:15px;
    display:flex;
    gap:10px;
    border-top:1px solid #ddd;
}

.sendBox input{
    flex:1;
    padding:12px;
    border-radius:25px;
    border:1px solid #ccc;
}

.sendBox button{
    padding:12px 25px;
    border:none;
    background:#4a69bd;
    color:white;
    border-radius:25px;
    cursor:pointer;
}

.sendBox button:hover{
    background:#365899;
}

.messageImage{
    max-width:220px;
    max-height:220px;
    border-radius:10px;
    display:block;
    margin-top:6px;
}

.messageVideo{
    max-width:250px;
    border-radius:10px;
    display:block;
    margin-top:6px;
}

.messageFile{
    display:inline-block;
    margin-top:6px;
    padding:8px 12px;
    background:#f0f0f0;
    border-radius:8px;
    text-decoration:none;
    color:#333;
    font-size:13px;
}

.fileButton{
    cursor:pointer;
    font-size:22px;
    padding:0 10px;
    user-select:none;
}

.online{
    width:10px;
    height:10px;
    border-radius:50%;
    background:#00c851;
    display:inline-block;
    margin-left:8px;
}

</style>

</head>

<body>

<div class="header">

    <div class="datetime">
        <div id="date"></div>
        <div id="clock"></div>
    </div>

    <h1>Messagerie privée</h1>

    <div class="menu">

<a href="${pageContext.request.contextPath}/dummy">
            Accueil
        </a>

        <a href="#">
            Emploi du temps
        </a>

        <a href="${pageContext.request.contextPath}/notes">
            Notes
        </a>

        <a href="${pageContext.request.contextPath}/logout">
            Logout
        </a>

    </div>

</div>

<div class="container">

<div class="leftPanel">

    <div class="search">

        <input
            type="text"
            id="contactSearch"
            placeholder="Rechercher un utilisateur..."
            autocomplete="off">

    </div>

    <c:forEach var="user" items="${users}">

    <c:if test="${user.user_email != currentUser}">

        <div class="userCard"
             data-name="${user.user_fname} ${user.user_lname} ${user.user_email}"
             onclick="openConversation('${user.user_email}',
                                       '${user.user_fname} ${user.user_lname}')">

            <c:choose>

                <c:when test="${not empty user.user_photo}">
                    <img src="${pageContext.request.contextPath}/uploads/${user.user_photo}"
                         class="avatarImg" alt="avatar">
                </c:when>

                <c:otherwise>
                    <div class="avatar">
                        ${user.user_fname.substring(0,1)}
                    </div>
                </c:otherwise>

            </c:choose>

            <div class="userInfo">

                <div class="userName">

                    ${user.user_fname}
                    ${user.user_lname}

                    <span class="online"></span>

                </div>

                <div class="lastMessage">

                    Cliquez pour ouvrir la conversation

                </div>

            </div>

        </div>

</c:if>

    </c:forEach>

    <div id="noResults" style="display:none; padding:20px; text-align:center; color:#888;">
        Aucun résultat
    </div>

</div>

<div class="rightPanel">

    <c:set var="conversationUser" value="${null}" />

    <c:forEach var="u" items="${users}">
        <c:if test="${u.user_email == receiver}">
            <c:set var="conversationUser" value="${u}" />
        </c:if>
    </c:forEach>

    <div class="chatHeader"
         id="chatHeader">

        <c:choose>

            <c:when test="${not empty conversationUser}">

                <div class="chatHeaderContent">

                    <c:choose>
                        <c:when test="${not empty conversationUser.user_photo}">
                            <img src="${pageContext.request.contextPath}/uploads/${conversationUser.user_photo}"
                                 class="avatarImgSmall" alt="avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar">
                                ${conversationUser.user_fname.substring(0,1)}
                            </div>
                        </c:otherwise>
                    </c:choose>

                    ${conversationUser.user_fname} ${conversationUser.user_lname}

                </div>

                <div class="typingIndicator" id="typingIndicator"></div>

            </c:when>

            <c:otherwise>
                Sélectionnez une conversation
            </c:otherwise>

        </c:choose>

    </div>

    <div class="messages"
         id="messages">

<c:set var="lastOwnMessageId" value="0" />

<c:forEach var="m" items="${messages}">
    <c:if test="${m.sender == sessionScope.username}">
        <c:set var="lastOwnMessageId" value="${m.id}" />
    </c:if>
</c:forEach>

<c:forEach var="message" items="${messages}">

    <c:choose>

        <c:when test="${message.sender == sessionScope.username}">

            <div class="messageMine">

                <div class="bubbleMine">

                    ${message.content}

                    <c:if test="${not empty message.fileName}">

                        <c:set var="lowerFileName" value="${fn:toLowerCase(message.fileName)}" />

                        <c:choose>

                            <c:when test="${fn:endsWith(lowerFileName, '.jpg') or fn:endsWith(lowerFileName, '.jpeg') or fn:endsWith(lowerFileName, '.png') or fn:endsWith(lowerFileName, '.gif') or fn:endsWith(lowerFileName, '.webp')}">
                                <img src="${pageContext.request.contextPath}/uploads/${message.fileName}" class="messageImage" alt="image">
                            </c:when>

                            <c:when test="${fn:endsWith(lowerFileName, '.mp4') or fn:endsWith(lowerFileName, '.webm') or fn:endsWith(lowerFileName, '.mov')}">
                                <video controls class="messageVideo">
                                    <source src="${pageContext.request.contextPath}/uploads/${message.fileName}">
                                </video>
                            </c:when>

                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/uploads/${message.fileName}" target="_blank" class="messageFile">
                                    📄 ${message.fileName}
                                </a>
                            </c:otherwise>

                        </c:choose>

                    </c:if>

                </div>

                <div class="time">

                    ${message.formattedSendDate}

                </div>

                <c:if test="${message.id == lastOwnMessageId}">

                    <div class="statusIndicator" id="status-${message.id}">
                        <c:choose>
                            <c:when test="${message.readMessage}">Lu ✓✓</c:when>
                            <c:otherwise>Envoyé ✓</c:otherwise>
                        </c:choose>
                    </div>

                </c:if>

            </div>

        </c:when>

        <c:otherwise>

            <div class="messageOther">

                <div class="bubbleOther">

                    ${message.content}

                    <c:if test="${not empty message.fileName}">

                        <c:set var="lowerFileName" value="${fn:toLowerCase(message.fileName)}" />

                        <c:choose>

                            <c:when test="${fn:endsWith(lowerFileName, '.jpg') or fn:endsWith(lowerFileName, '.jpeg') or fn:endsWith(lowerFileName, '.png') or fn:endsWith(lowerFileName, '.gif') or fn:endsWith(lowerFileName, '.webp')}">
                                <img src="${pageContext.request.contextPath}/uploads/${message.fileName}" class="messageImage" alt="image">
                            </c:when>

                            <c:when test="${fn:endsWith(lowerFileName, '.mp4') or fn:endsWith(lowerFileName, '.webm') or fn:endsWith(lowerFileName, '.mov')}">
                                <video controls class="messageVideo">
                                    <source src="${pageContext.request.contextPath}/uploads/${message.fileName}">
                                </video>
                            </c:when>

                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/uploads/${message.fileName}" target="_blank" class="messageFile">
                                    📄 ${message.fileName}
                                </a>
                            </c:otherwise>

                        </c:choose>

                    </c:if>

                </div>

                <div class="time">

                    ${message.formattedSendDate}

                </div>

            </div>

        </c:otherwise>

    </c:choose>

</c:forEach>

</div>

<div class="sendArea">

    <form action="${pageContext.request.contextPath}/sendMessage"
          method="post"
          enctype="multipart/form-data">

        <input
            type="hidden"
            id="receiver"
            name="receiver">

        <input
            type="text"
            id="messageInput"
            name="content"
            placeholder="Écrire un message..."
            autocomplete="off">

        <label for="fileInput" class="fileButton">📎</label>
        <input
            type="file"
            id="fileInput"
            name="file"
            accept=".pdf,image/*,video/*"
            style="display:none;">

        <button type="submit">

            Envoyer

        </button>

    </form>

</div>

</div>

</div>

<script>

function openConversation(email)
{
    window.location =
        "${pageContext.request.contextPath}/messages/" + email;
}

const receiverField = document.getElementById("receiver");

const currentConversation =
"${receiver}";

if(receiverField)
{
    receiverField.value = currentConversation;
}

const messages =
document.getElementById("messages");

if(messages)
{
    messages.scrollTop =
    messages.scrollHeight;
}

const input =
document.getElementById("messageInput");

if(input)
{
    input.focus();
}

</script>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>

let notifSocket =
    new SockJS("${pageContext.request.contextPath}/chat");

let notifStomp =
    Stomp.over(notifSocket);

const myUsername = "${sessionScope.username}";
const openReceiver = "${receiver}";

let typingTimeout;

notifStomp.connect({}, function() {

    notifStomp.subscribe(
        "/topic/messages/" + myUsername,

        function(frame) {

            const message = JSON.parse(frame.body);

            if(openReceiver !== "" && message.sender === openReceiver) {

                location.reload();

            } else {

                showNotificationPopup(message.sender, message.content || "📎 Fichier envoyé");
                incrementUnreadBadge();

            }

        });

    notifStomp.subscribe(
        "/topic/typing/" + myUsername,

        function(frame) {

            const typingMessage = JSON.parse(frame.body);

            if(openReceiver !== "" && typingMessage.sender === openReceiver) {

                showTypingIndicator(typingMessage.sender);

            }

        });

    notifStomp.subscribe(
        "/topic/read/" + myUsername,

        function(frame) {

            const readMessage = JSON.parse(frame.body);

            const statusDiv =
                document.getElementById("status-" + readMessage.id);

            if(statusDiv) {
                statusDiv.textContent = "Lu ✓✓";
            }

        });

});

function showTypingIndicator(senderEmail) {

    let senderName = senderEmail;

    <c:forEach var="u" items="${users}">
        if(senderEmail === "${u.user_email}") {
            senderName = "${u.user_fname} ${u.user_lname}";
        }
    </c:forEach>

    const indicator = document.getElementById("typingIndicator");

    indicator.textContent = senderName + " est en train d'écrire...";
    indicator.style.display = "block";

    clearTimeout(typingTimeout);

    typingTimeout = setTimeout(function() {
        indicator.style.display = "none";
    }, 3000);
}

const messageInputField = document.getElementById("messageInput");

if(messageInputField) {

    messageInputField.addEventListener("input", function() {

        if(openReceiver !== "") {

            notifStomp.send(
                "/app/typing",
                {},
                JSON.stringify({
                    sender: myUsername,
                    receiver: openReceiver
                })
            );

        }

    });

}

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

const contactSearchField = document.getElementById("contactSearch");

if(contactSearchField) {

    contactSearchField.addEventListener("input", function() {

        const searchTerm = contactSearchField.value.toLowerCase();

        let visibleCount = 0;

        document.querySelectorAll(".userCard").forEach(function(card) {

            const name = card.dataset.name.toLowerCase();

            if(name.includes(searchTerm)) {
                card.style.display = "";
                visibleCount = visibleCount + 1;
            } else {
                card.style.display = "none";
            }

        });

        const noResultsDiv = document.getElementById("noResults");

        if(visibleCount === 0) {
            noResultsDiv.style.display = "block";
        } else {
            noResultsDiv.style.display = "none";
        }

    });

}

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

updateDateTime();
setInterval(updateDateTime, 1000);

</script>
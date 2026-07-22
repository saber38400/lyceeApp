<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
uri="jakarta.tags.core"%>

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
}

.search input{
    width:100%;
    padding:10px;
    border-radius:20px;
    border:1px solid #ccc;
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

.messages{
    flex:1;
    overflow-y:auto;
    padding:20px;
    background:#e5ddd5;
}

.messageMine{
    display:flex;
    justify-content:flex-end;
    margin-bottom:15px;
}

.messageOther{
    display:flex;
    justify-content:flex-start;
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

    <h1>Messagerie privée</h1>

    <div class="menu">

<a href="${pageContext.request.contextPath}/dummy">
            Accueil
        </a>

        <a href="#">
            Messagerie
            <span class="unreadBadge"
                  style="${unreadCount > 0 ? '' : 'display:none;'}">${unreadCount}</span>
        </a>

    </div>

</div>

<div class="container">

<div class="leftPanel">

    <div class="search">

        <input
            type="text"
            placeholder="Rechercher un utilisateur...">

    </div>

    <c:forEach var="user" items="${users}">

    <c:if test="${user.user_email != currentUser}">

        <div class="userCard"
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

            </c:when>

            <c:otherwise>
                Sélectionnez une conversation
            </c:otherwise>

        </c:choose>

    </div>

    <div class="messages"
         id="messages">

<c:forEach var="message" items="${messages}">

    <c:choose>

        <c:when test="${message.sender == sessionScope.username}">

            <div class="messageMine">

                <div class="bubbleMine">

                    ${message.content}

                </div>

                <div class="time">

                    ${message.formattedSendDate}

                </div>

            </div>

        </c:when>

        <c:otherwise>

            <div class="messageOther">

                <div class="bubbleOther">

                    ${message.content}

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
          method="post">

        <input
            type="hidden"
            id="receiver"
            name="receiver">

        <input
            type="text"
            id="messageInput"
            name="content"
            placeholder="Écrire un message..."
            autocomplete="off"
            required>

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

notifStomp.connect({}, function() {

    notifStomp.subscribe(
        "/topic/messages/" + myUsername,

        function(frame) {

            const message = JSON.parse(frame.body);

            if(openReceiver !== "" && message.sender === openReceiver) {

                location.reload();

            } else {

                showNotificationPopup(message.sender, message.content);
                incrementUnreadBadge();

            }

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
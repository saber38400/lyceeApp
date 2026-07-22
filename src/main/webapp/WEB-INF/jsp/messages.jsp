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
            Messagerie (${unreadCount})
        </a>

        <a href="${pageContext.request.contextPath}/logout">
            Déconnexion
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

        <div class="userCard"
             onclick="openConversation('${user.user_email}',
                                       '${user.user_fname} ${user.user_lname}')">

            <div class="avatar">

                ${user.user_fname.substring(0,1)}

            </div>

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

    </c:forEach>

</div>

<div class="rightPanel">

    <div class="chatHeader"
         id="chatHeader">

        Sélectionnez une conversation

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

                    ${message.sendDate}

                </div>

            </div>

        </c:when>

        <c:otherwise>

            <div class="messageOther">

                <div class="bubbleOther">

                    ${message.content}

                </div>

                <div class="time">

                    ${message.sendDate}

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
        "${pageContext.request.contextPath}/messages?user=" + email;
}

const receiverField = document.getElementById("receiver");

const currentConversation =
"${selectedUser}";

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

let socket =
new SockJS("${pageContext.request.contextPath}/chat");

let stompClient =
Stomp.over(socket);

stompClient.connect({}, function(){

    stompClient.subscribe(
        "/user/queue/messages",

        function(message){

            location.reload();

        });

});

</script>
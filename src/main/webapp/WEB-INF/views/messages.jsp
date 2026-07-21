<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

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
font-family:Arial,Helvetica,sans-serif;
}

body{

background:#eef2f7;

height:100vh;

overflow:hidden;

}

.header{

height:70px;

background:#4a69bd;

color:white;

display:flex;

justify-content:space-between;

align-items:center;

padding-left:30px;

padding-right:30px;

}

.header h2{

font-size:28px;

}

.header a{

color:white;

text-decoration:none;

font-weight:bold;

margin-left:20px;

}

.main{

display:flex;

height:calc(100vh - 70px);

}

.left{

width:350px;

background:white;

border-right:1px solid #ddd;

display:flex;

flex-direction:column;

}

.search{

padding:20px;

}

.search input{

width:100%;

padding:12px;

border-radius:25px;

border:1px solid #ccc;

outline:none;

}

.contacts{

overflow-y:auto;

flex:1;

}

.contact{

display:flex;

align-items:center;

padding:15px;

cursor:pointer;

text-decoration:none;

color:black;

border-bottom:1px solid #eee;

transition:0.2s;

}

.contact:hover{

background:#f2f2f2;

}

.avatar{

width:55px;

height:55px;

border-radius:50%;

background:#4a69bd;

display:flex;

justify-content:center;

align-items:center;

color:white;

font-size:22px;

font-weight:bold;

margin-right:15px;

}

.contact-info{

flex:1;

}

.contact-name{

font-weight:bold;

font-size:17px;

}

.contact-last{

color:gray;

font-size:13px;

margin-top:5px;

}

.right{

flex:1;

display:flex;

flex-direction:column;

background:#f8f9fb;

}

.chat-header{

height:70px;

background:white;

display:flex;

align-items:center;

padding-left:25px;

border-bottom:1px solid #ddd;

font-size:22px;

font-weight:bold;

}

.messages{

flex:1;

overflow-y:auto;

padding:30px;

display:flex;

flex-direction:column;

}

.me{

align-self:flex-end;

background:#4a69bd;

color:white;

padding:12px 18px;

border-radius:20px;

margin-bottom:12px;

max-width:60%;

word-wrap:break-word;

}

.other{

align-self:flex-start;

background:white;

padding:12px 18px;

border-radius:20px;

margin-bottom:12px;

max-width:60%;

word-wrap:break-word;

box-shadow:0 0 5px rgba(0,0,0,.1);

}

.bottom{

height:90px;

background:white;

display:flex;

align-items:center;

padding:15px;

border-top:1px solid #ddd;

}

.bottom input{

flex:1;

padding:14px;

border-radius:25px;

border:1px solid #ccc;

outline:none;

font-size:15px;

}

.bottom button{

margin-left:15px;

background:#4a69bd;

color:white;

border:none;

padding:14px 30px;

border-radius:25px;

cursor:pointer;

font-size:15px;

}

.bottom button:hover{

background:#3656aa;

}

</style>

</head>

<body>

<div class="header">

<h2>Messagerie</h2>

<div>

<a href="${pageContext.request.contextPath}/dummy">

Accueil

</a>

<a href="${pageContext.request.contextPath}/logout">

Logout

</a>

</div>

</div>
<div class="main">

<div class="left">

<div class="search">

<input

type="text"

placeholder="Rechercher un élève...">

</div>

<div class="contacts">

<c:forEach var="user"

items="${users}">

<c:if test="${user.user_email != currentUser}">

<a

class="contact"

href="${pageContext.request.contextPath}/messages/${user.user_email}">

<div class="avatar">

${user.user_fname.substring(0,1)}

</div>

<div class="contact-info">

<div class="contact-name">

${user.user_fname}

${user.user_lname}

</div>

<div class="contact-last">

Cliquez pour discuter

</div>

</div>

</a>

</c:if>

</c:forEach>

</div>

</div>
<div class="right">

<div class="chat-header">

<c:choose>

<c:when test="${receiver != null}">

Conversation avec ${receiver}

</c:when>

<c:otherwise>

Sélectionnez une conversation

</c:otherwise>

</c:choose>

</div>

<div class="messages">

<c:forEach

var="message"

items="${messages}">

<c:choose>

<c:when test="${message.sender==currentUser}">

<div class="me">

${message.content}

</div>

</c:when>

<c:otherwise>

<div class="other">

${message.content}

</div>

</c:otherwise>

</c:choose>

</c:forEach>

</div>
<form

action="${pageContext.request.contextPath}/sendMessage"

method="post"

class="bottom">

<input

type="hidden"

name="receiver"

value="${receiver}">

<input

type="text"

name="content"

placeholder="Écrire un message...">

<button>

Envoyer

</button>

</form>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

let socket =
    new SockJS("/chat");

let stomp =
    Stomp.over(socket);

stomp.connect({}, function () {

    stomp.subscribe("/topic/messages", function(message){

        const msg =
            JSON.parse(message.body);

        if(msg.sender===currentUser &&
           msg.receiver===selectedUser ||

           msg.sender===selectedUser &&
           msg.receiver===currentUser){

            addMessage(msg);

        }

        loadConversations();

    });

});

</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Messagerie</title>

<style>

body{
    margin:0;
    font-family:Arial,Helvetica,sans-serif;
    background:#edf2f7;
}

.header{
    background:#4a69bd;
    color:white;
    padding:20px;
}

.header a{
    color:white;
    text-decoration:none;
    font-weight:bold;
}

.container{
    display:flex;
    height:88vh;
}

.left{
    width:320px;
    background:white;
    border-right:1px solid #ddd;
    overflow-y:auto;
}

.right{
    flex:1;
    display:flex;
    flex-direction:column;
    background:#f7f7f7;
}

.user{
    padding:18px;
    border-bottom:1px solid #eee;
    cursor:pointer;
}

.user:hover{
    background:#f3f3f3;
}

.messages{
    flex:1;
    overflow-y:auto;
    padding:20px;
}

.mine{
    text-align:right;
    margin:10px;
}

.other{
    text-align:left;
    margin:10px;
}

.bubbleMine{
    display:inline-block;
    background:#4a69bd;
    color:white;
    padding:10px;
    border-radius:15px;
}

.bubbleOther{
    display:inline-block;
    background:white;
    padding:10px;
    border-radius:15px;
}

.sendBox{
    padding:15px;
    background:white;
    border-top:1px solid #ddd;
}

textarea{
    width:100%;
    height:70px;
}

button{
    margin-top:10px;
    padding:10px 20px;
    background:#4a69bd;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
}

</style>

</head>

<body>

<div class="header">

<h2>Messagerie privée</h2>

<a href="${pageContext.request.contextPath}/dummy">
← Retour
</a>

</div>

<div class="container">

<div class="left">

<c:forEach var="user" items="${users}">

<div class="user">

<a href="${pageContext.request.contextPath}/messages?receiver=${user.user_email}">

${user.user_fname}
${user.user_lname}

</a>

</div>

</c:forEach>

</div>

<div class="right">

<div class="messages" id="messages">

<c:forEach var="message" items="${messages}">

<c:choose>

<c:when test="${message.sender==sessionScope.username}">

<div class="mine">

<div class="bubbleMine">

${message.content}

</div>

</div>

</c:when>

<c:otherwise>

<div class="other">

<div class="bubbleOther">

${message.content}

</div>

</div>

</c:otherwise>

</c:choose>

</c:forEach>

</div>

<div class="sendBox">

<form action="${pageContext.request.contextPath}/sendMessage"

method="post">

<input
type="hidden"
name="receiver"
value="${receiver}">

<textarea
name="content"
placeholder="Écrire un message..."></textarea>

<button>

Envoyer

</button>

</form>

</div>

</div>

</div>

</body>

</html>
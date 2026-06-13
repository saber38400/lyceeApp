<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
<title>Messagerie</title>
</head>

<body>

<h1>Messagerie privée</h1>

<div id="messages"></div>

<input type="text" id="receiver" placeholder="Destinataire">

<br><br>

<input type="text" id="content" placeholder="Message">

<button onclick="sendMessage()">
Envoyer
</button>

</body>
</html>
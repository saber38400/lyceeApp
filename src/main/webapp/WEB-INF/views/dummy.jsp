<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Espace Étudiant</title>

<style>

body{
    margin:0;
    font-family:Arial, Helvetica, sans-serif;
    background:#f2f2f2;
}

.header{
    background:#4a69bd;
    color:white;
    padding:20px;
    text-align:center;
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

textarea{
    width:100%;
    height:100px;
    padding:10px;
}

button{
    background:#4a69bd;
    color:white;
    border:none;
    padding:10px 20px;
    margin-top:10px;
    border-radius:5px;
    cursor:pointer;
}

.menu{
    display:flex;
    gap:20px;
    margin-top:15px;
}

.menu a{
    text-decoration:none;
    color:white;
    font-weight:bold;
}

.post{
    background:#ffffff;
    padding:15px;
    border-radius:10px;
    margin-top:15px;
}

</style>

</head>

<body>

<div class="header">

    <h1>Espace Étudiant</h1>

    <p>Bienvenue ${sessionScope.username}</p>

    <div class="menu">
        <a href="#">Messagerie</a>
        <a href="#">Emploi du temps</a>
        <a href="#">Notes</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>

</div>

<div class="container">

    <div class="card">

        <h2>Créer une publication</h2>

        <form method="post">

            <textarea placeholder="Écris quelque chose..."></textarea>

            <br>

            <button type="submit">Publier</button>

        </form>

    </div>

    <div class="card">

        <h2>Fil d'actualité</h2>

        <div class="post">
            <h3>Annonce école</h3>
            <p>Bienvenue sur le nouveau réseau scolaire du lycée.</p>
        </div>

        <div class="post">
            <h3>Vie scolaire</h3>
            <p>Les emplois du temps seront bientôt disponibles.</p>
        </div>

    </div>

</div>

</body>
</html>
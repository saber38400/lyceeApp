<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

.datetime{
    position:absolute;
    top:20px;
    right:30px;
    color:white;
    text-align:right;
    font-size:14px;
    font-weight:bold;
}

</style>

</head>

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

setInterval(updateDateTime, 1000);

updateDateTime();

</script>

<body>

<div class="header">

    <div class="datetime">
    <div id="date"></div>
    <div id="clock"></div>
</div>

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

    <form action="${pageContext.request.contextPath}/createPost"
        method="post"
        enctype="multipart/form-data">

        <textarea name="content"
                placeholder="Écris quelque chose..."></textarea>

        <br><br>

        <input type="file" name="file">

        <br>

        <button type="submit">Publier</button>

    </form>

    </div>

    <div class="card">

        <h2>Fil d'actualité</h2>

<c:forEach var="post" items="${posts}">

    <div class="post">

        <div style="display:flex; justify-content:space-between; align-items:center;">

            <h3>${post.author}</h3>

            <div>

                <button onclick="toggleEdit('${post.id}')">
                    Modifier
                </button>

                <a href="${pageContext.request.contextPath}/deletePost/${post.id}">
                    <button type="button">
                        Supprimer
                    </button>
                </a>

            </div>

        </div>

        <c:if test="${not empty post.content}">
            <p>${post.content}</p>
        </c:if>

        <div id="edit-${post.id}" style="display:none; margin-top:10px;">

            <form action="${pageContext.request.contextPath}/editPost"
                  method="post">

                <input type="hidden"
                        name="id"
                        value="${post.id}">

                <textarea name="content">${post.content}</textarea>

                <br>

                <button type="submit">
                    Sauvegarder
                </button>

            </form>

        </div>

        <c:if test="${not empty post.fileName}">

            <c:choose>

                <c:when test="${post.fileType.startsWith('image')}">

                    <img src="${pageContext.request.contextPath}/uploads/${post.fileName}"
                         width="300">

                </c:when>

                <c:when test="${post.fileType.startsWith('video')}">

                    <video width="400" controls>
                        <source src="${pageContext.request.contextPath}/uploads/${post.fileName}">
                    </video>

                </c:when>

            </c:choose>

            <br><br>

            <a href="${pageContext.request.contextPath}/download/${post.fileName}">
                <button type="button">
                    Télécharger
                </button>
            </a>

            <a href="${pageContext.request.contextPath}/deleteFile/${post.id}">
                <button type="button">
                    Supprimer le fichier
                </button>
            </a>
        </c:if>

    </div>

</c:forEach>

    </div>

</div>
    <script>

    function toggleEdit(id)
    {
        const element = document.getElementById("edit-" + id);

        if(element.style.display === "none")
        {
            element.style.display = "block";
        }
        else
        {
            element.style.display = "none";
        }
    }

    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"

                    <c:choose>

                        <c:when test="${post.fileType.startsWith('image')}">

                            <img src="/uploads/${post.fileName}">

                        </c:when>

                        <c:when test="${post.fileType.startsWith('video')}">

                            <video controls>
                                <source src="/uploads/${post.fileName}">
                            </video>

                        </c:when>

                    </c:choose>

                </c:if>

            </div>

        </c:forEach>

    </div>

    <div class="card">

        <h2>Emploi du temps</h2>

        <div class="schedule-item">
            08:00 - Mathématiques
        </div>

        <div class="schedule-item">
            10:00 - Informatique
        </div>

        <div class="schedule-item">
            13:00 - Anglais
        </div>

        <div class="schedule-item">
            15:00 - Sport
        </div>

    </div>

</div>

</body>
</html>
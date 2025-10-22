<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>

    let ai2center = {
        init: function(){
            this.display();
        },
        display: function(){
            document.addEventListener('DOMContentLoaded', function() {
                var calendarEl = document.getElementById('calendar');
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth'
                });
                calendar.render();
            });
        }
    }
    $(()=>{
        ai2center.init();
    });

</script>

<div class="col-sm-10">
    <h2>AI2 Structured Chat System</h2>
    <div id='calendar'></div>
</div>


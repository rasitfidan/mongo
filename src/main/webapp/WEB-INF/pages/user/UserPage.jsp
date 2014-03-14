<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>  
<head>  
<link rel="stylesheet" href="<c:url value="resources/css/jquery-ui.css" />">
<script type="text/javascript" src="<c:url value="resources/js/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="resources/js/jquery-ui.js" />"></script>

<title>Kullanici Sayfasi</title>  
<script>   
    $(document).ready(function(){
        $(document).ajaxStart(function(){
          $("#wait").css("display","block");
        });
        
        $(document).ajaxComplete(function(){
          $("#wait").css("display","none");
        });
        
        loadUsers();
    });
    
    function openNewUserPopup(){
        alert("openNewUserPopup");
    }
    
    function loadUsers(){
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "user/list",
            success: function (reqResult) {
                decorateUserTable(reqResult);
            }
        });
    }
    
    function decorateUserTable(reqResult) {
        if(reqResult.successfull){
            var userResultList = reqResult.resultList;
            
            var uTable = document.getElementById("userTable");
            
            var uTableBody = uTable.tBodies[0];
            //eski datasi tablodan cikar
            uTableBody.remove();
            
            uTableBody = document.createElement("TBODY");
            
            for(var i=0 ; i<userResultList.length; i++){
                var user = userResultList[i];
                
                var tRow = document.createElement("TR");
                
                var td1 = document.createElement("TD");
                
                td1.appendChild(document.createTextNode(user.name));
                
                tRow.appendChild(td1);
                
                var td2 = document.createElement("TD");
                
                td2.appendChild(document.createTextNode(user.surname));
                
                tRow.appendChild(td2);
                
                var td3 = document.createElement("TD");
                
                td3.appendChild(document.createTextNode(user.telNo));
                
                tRow.appendChild(td3);
                
                //Buttonlar
                var td4 = document.createElement("TD");
                
                var buttonUpdate = document.createElement("BUTTON");
                
                buttonUpdate.appendChild(document.createTextNode("Guncelle")) ;  
                
                buttonUpdate.setAttribute("onclick","newOrUpdateUserPopupOpen('"+user.id+"','"+user.name+"','"+user.surname+"','"+user.telNo+"');");
                
                td4.appendChild(buttonUpdate);
                
                tRow.appendChild(td4);
                
                var td5 = document.createElement("TD");
                
                var buttonDelete = document.createElement("BUTTON");
                
                buttonDelete.appendChild(document.createTextNode("Sil")) ;  
                
                buttonDelete.setAttribute("onclick","deleteUser('"+user.id+"');");
                
                td5.appendChild(buttonDelete);
                
                tRow.appendChild(td5);
                
                
                uTableBody.appendChild(tRow);
            }
            //Yeni datayi tabloya ekle
            uTable.appendChild(uTableBody);
            //{"successfull":true,"messages":[],"resultList":[{"id":"5321d120504c26ea8e362188","name":"rasit","surname":"Fidan2","telNo":"02122833034"}]}
        } else {
            var error = reqResult.messages[0].ERROR;
            
            alert(error);
        }
    }
    
    function deleteUser(id){
        
    }
    
    function changeCaptchaImage(){
         document.getElementById("captchaDiv").innerHTML="<img id='captchaImg' src='<c:url value="captcha" />' height='50' width='100'/>"; alert("Yenilemiyor! Bug!");
    }
    
    function newOrUpdateUserPopupOpen(id,name,surname,telNo) {
        var action = null;
        //update
        if(id!==null && id !=="") {
            action = "user/update";
        } else {
            action = "user/create";
        }
        
        $(function() {
            $( "#modaldialog" ).dialog({
                height: 300,
                width: 400,
                modal: true
            });
        });
    }
</script>

</head>  
<body>  
      
    <center>  
        <h2>Kullanici Yonetimi</h2>  
        <table style="width: 500px">
            <tr>            
                <td>    
                    <table id="userTable" style="width:500px">
                         <thead>
                            <tr>
                               <th>Isim</th>
                               <th>Soy Isim</th>
                               <th>Telefon</th>
                            </tr>
                         </thead>
                         <tbody>
                         </tbody>
                    </table>
                <td>
            </tr>
            <tr>            
                <td>
                    <button onclick="newOrUpdateUserPopupOpen()">Yeni Kullanici</button> 
                <td>
            </tr>            
        </table>
        <div id="modaldialog" style="display:none;">
            <table>
                <tr>
                    <td>
                        Isim
                    </td>
                    <td>
                        <input type="text" name="name"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        Soy Isim
                    </td>
                    <td>
                        <input type="text" name="surname"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Telefon
                    </td>
                    <td>
                        <input type="text" name="telNo"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Asagida ne yaziyor?
                    </td>
                    <td>
                        <input type="text" name="captcha"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id="captchaDiv"><img id="captchaImg" src="<c:url value="captcha" />" height="50" width="100"/></div>
                    </td>
                    <!--td>
                        <button onclick="changeCaptchaImage();">Yenile</button>
                    </td-->
                </tr>
                <tr>
                    <td>
                        <button id="saveButton" onclick="saveUser();">Kaydet</button>
                    </td>
                    <td>
                         <button id="saveButton" onclick="closePopup();">Kapat</button>
                    </td>
                </tr>
            </table>
        </div>
        <div id="wait" style="display:none;width:105px;height:150px;border:1px solid black;position:absolute;top:50%;left:50%;padding:2px;"><img src='<c:url value="resources/img/ajax-loader1.gif" />' width="100" height="100" /><br>Loading..</div>
    </center>  
</body>  
</html> 
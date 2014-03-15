<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>  
<head>  
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <link rel="stylesheet" href="<c:url value="resources/css/jquery-ui.css" />">
    <link rel="stylesheet" href="<c:url value="resources/css/style.css" />">
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

        function newOrUpdateUserPopupOpen(m_id,m_name,m_surname,m_telNo) {
            
            var action = null;
            var winTitle = null;
            //update
            if(m_id!==null && m_id !=="") {
                action = "user/update";
                winTitle = "Kullanici Guncelleme";
            } else {
                action = "user/create";
                winTitle = "Kullanici Tanimlama";
            }
            
            setNewValues(m_id,m_name,m_surname,m_telNo);
            
            $(function() {
                $( "#persistmodaldialog" ).dialog({
                    height: 400,
                    width: 450,
                    modal: true,
                    title : winTitle,
                    buttons: {
                        "Kaydet": function() {                            
                           alert($('#userId').val());
                            $.ajax({
                                type: "POST",
                                dataType: "json",
                                url: action,
                                data: { userid : m_id, name: m_name, surname: m_surname , telNo : m_telNo },
                                success: function (reqResult) {
                                    //postDelete(reqResult);                                    
                                    $( this ).dialog( "close" );
                                }
                            });
                        },
                        "Iptal": function() {
                            $( this ).dialog( "close" );
                        }
                    }
                });
            });
        }
        
        function setNewValues(m_id,m_name,m_surname,m_telNo) {
            $('#userId').val(m_id);
            $('#name').val(m_name);
            $('#surname').val(m_surname);
            $('#telNo').val(m_telNo);
            
            changeCaptchaImage();
        }
        
        function deleteUser(m_id){
            $(function() {
                $( "#deleteconfirm" ).dialog({
                    resizable: false,
                    height:200,
                    width: 450,
                    modal: true,
                    buttons: {
                        "Evet,Sil!": function() {
                            $.ajax({
                                type: "POST",
                                dataType: "json",
                                url: "user/delete",
                                data: { userid : m_id},
                                success: function (reqResult) {
                                    //postDelete(reqResult);                                    
                                    $( this ).dialog( "close" );
                                }
                            });
                        },
                        "Iptal": function() {
                            $( this ).dialog( "close" );
                        }
                    }
                });
           });
        }
        
        function changeCaptchaImage(){
            document.getElementById("captchaDiv").innerHTML="<img id='captchaImg' src='<c:url value="captcha?" />"+Math.random()+"' height='50' width='100'/>";
        }
        
        
</script>

</head>  
<body>  
      
    <center>  
        <div id="userListDiv">
            <table>
                <caption>Kullanici Yonetimi</caption>
                <tr>            
                    <td>    
                        <table id="userTable">
                             <thead>
                                <tr>
                                   <th>Isim</th>
                                   <th>Soyisim</th>
                                   <th>Telefon</th>
                                   <th></th>
                                   <th></th>
                                </tr>
                             </thead>
                             <tbody>
                             </tbody>
                        </table>
                    <td>
                </tr>
                <tr>            
                    <td>
                        <button onclick="newOrUpdateUserPopupOpen(null,null,null,null)">Yeni Kullanici</button> 
                    <td>
                </tr>            
            </table>
        </div>
        <div id="persistmodaldialog" style="display:none;">
            <table>
                <tr>
                    <td>
                        Isim
                    </td>
                    <td>
                        <input type="hidden" id="userId" name="userId"/>
                        <input type="text" id="name" name="name"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        Soyisim
                    </td>
                    <td>
                        <input type="text" id="surname" name="surname"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Telefon
                    </td>
                    <td>
                        <input type="text" id="telNo" name="telNo"/>
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
                    <td>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td><div id="captchaDiv"><img id="captchaImg" src="<c:url value="captcha" />" height="50" width="100"/></div></td>
                                <td><input type="image" src="resources/img/refreshIcon.png" onclick="changeCaptchaImage();"  width="40" height="32"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="deleteconfirm" title="Kullanici Silme" style="display:none;">
            <p></span>Kullaniciyi silmek istediginizden emin misiniz?</p>
        </div>
        <div id="wait" style="display:none;width:105px;height:150px;border:1px solid black;position:absolute;top:50%;left:50%;padding:2px;"><img src='<c:url value="resources/img/ajax-loader1.gif" />' width="100" height="100" /><br>Loading..</div>
    </center>  
</body>  
</html> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>  
<head>  
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <link rel="stylesheet" href="<c:url value="resources/css/jquery-ui.css" />">
    <link rel="stylesheet" href="<c:url value="resources/css/style.css" />">
    <script type="text/javascript" src="<c:url value="resources/js/jquery.js" />"></script>
    <script type="text/javascript" src="<c:url value="resources/js/jquery-ui.js" />"></script>

    <title>Kullanici Yonetimi Sayfasi</title>  
    <script>   
        $(document).ready(function(){
            $(document).ajaxStart(function(){
                $(".loader").show();
              //$("#wait").css("display","block");
            });

            $(document).ajaxComplete(function(){
                $(".loader").hide();
              //$("#wait").css("display","none");
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
                //eski datayi tablodan cikar
                uTable.removeChild(uTableBody);

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

                    var buttonUpdate = document.createElement("INPUT");

                    buttonUpdate.setAttribute("type","image");
                    
                    buttonUpdate.setAttribute("alt","Guncelle");
                    
                    buttonUpdate.setAttribute("src","resources/img/edit.png");

                    buttonUpdate.setAttribute("onclick","newOrUpdateUserPopupOpen('"+user.id+"','"+user.name+"','"+user.surname+"','"+user.telNo+"');");

                    buttonUpdate.setAttribute("width","30");
                    
                    buttonUpdate.setAttribute("height","30");
                    
                    td4.appendChild(buttonUpdate);

                    tRow.appendChild(td4);

                    var td5 = document.createElement("TD");

                    var buttonDelete = document.createElement("INPUT");

                    buttonDelete.setAttribute("type","image");
                    
                    buttonDelete.setAttribute("alt","Sil");
                    
                    buttonDelete.setAttribute("src","resources/img/delete.png");

                    buttonDelete.setAttribute("onclick","deleteUser('"+user.id+"');");

                    buttonDelete.setAttribute("width","25");
                    
                    buttonDelete.setAttribute("height","25");
                    
                    td5.appendChild(buttonDelete);

                    tRow.appendChild(td5);


                    uTableBody.appendChild(tRow);
                }
                //Yeni datayi tabloya ekle
                uTable.appendChild(uTableBody);
            } else {
                var error = reqResult.messages[0].ERROR;

                alert(error);
            }
        }

        function newOrUpdateUserPopupOpen(m_id,m_name,m_surname,m_telNo) {
            var action = null;
            var winTitle = null;
            var m_captcha = null;
            
            var height = 400;
            
            var dialogType = "create";
            
            //update
            if(m_id!==null && m_id !=="") {
                action = "user/update";
                winTitle = "Kullanici Guncelleme";
                
                dialogType = "update";
                
                height = 270;
            } else {
                action = "user/create";
                winTitle = "Kullanici Tanimlama";
                
                dialogType = "create";
                
                height = 400;
            }
            
            var dialogName = "#"+dialogType+"dialog";
            var dialogErrorPaneName = "#"+dialogType+"DialogErrorPane";
            
            setNewValues(m_id,m_name,m_surname,m_telNo);
            
            $( dialogName ).dialog({
                height: height,
                width: 500,
                modal: true,
                title : winTitle,
                buttons: {
                    "Kaydet": function() {      
                        m_name = $('#'+dialogType+'name').val();
                        m_surname = $('#'+dialogType+'surname').val();
                        m_telNo = $('#'+dialogType+'telNo').val();

                        m_captcha = $('#captcha').val();

                       var errorMessages = "";

                       if(m_name==="") {
                          errorMessages+="<li>Isim</li>"; 
                       }

                       if(m_surname==="") {
                          errorMessages+="<li>Soyisim</li>"; 
                       }

                       if(m_captcha==="" && (m_id===null || m_id ==="")) {
                          errorMessages+="<li>Captcha</li>"; 
                       }

                       if(errorMessages!==""){
                            var dialogErrPane = $( dialogErrorPaneName );

                            dialogErrPane.html("<p>Asagidaki alanlar zorunludur</p>" +
                                                    "<ul>"+
                                                        errorMessages+
                                                    "</ul>");
                            
                            dialogErrPane.css("display","block");
                            //goz karari
                            $(this).height(height-50);
                       } else {
                            $.ajax({
                                 type: "POST",
                                 dataType: "json",
                                 url: action,
                                 data: { userid : m_id, name: m_name, surname: m_surname , telNo : m_telNo ,captcha : m_captcha},
                                 success : function (reqResult) {
                                     if(reqResult.successfull){
                                         loadUsers();
                                         $( dialogName ).dialog("close");
                                     } else{
                                         var dialogErrPane = $( dialogErrorPaneName );

                                        dialogErrPane.html(reqResult.messages[0].ERROR);

                                        dialogErrPane.css("display","block");
                                        
                                        $( dialogName ).height(height-50);
                                     }
                                 }
                             });
                        }
                    },
                    "Iptal": function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        }
        
        function setNewValues(m_id,m_name,m_surname,m_telNo) {
            var dialogType="create";
            //update
            if(m_id!==null && m_id !=="") {
                dialogType="update";
            } else {
                dialogType="create";
                
                $('#captcha').val("");
            
                changeCaptchaImage();
            }
            
            $('#userId').val(m_id);
            $('#'+dialogType+'name').val(m_name);
            $('#'+dialogType+'surname').val(m_surname);
            $('#'+dialogType+'telNo').val(m_telNo);
            
            var dialogErrPane = $( "#"+dialogType+"DialogErrorPane" );
            
            dialogErrPane.html("");
            
            dialogErrPane.css("display","none");
        }
        
        function deleteUser(m_id){
            $( "#deleteconfirm" ).dialog({
                resizable: false,
                height:200,
                width: 450,
                modal: true,
                title: "Kullanici Silme",
                buttons: {
                    "Evet,Sil!": function() {
                        $.ajax({
                            type: "POST",
                            dataType: "json",
                            url: "user/delete",
                            data: { userid : m_id},
                            success : function (reqResult) {                                
                                if(reqResult.successfull){
                                    loadUsers();
                                    $( "#deleteconfirm" ).dialog("close");
                                }
                            }
                        });
                    },
                    "Iptal": function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        }
        
        function changeCaptchaImage(){
            $( "#captchaDiv").html("<img id='captchaImg' src='<c:url value="captcha?" />"+Math.random()+"' height='50' width='100'/>");
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
                               <tr>
                                   <td>Isim</td>
                                   <td>Soyisim</td>
                                   <td>Telefon</td>
                                   <td></td>
                                   <td></td>
                                </tr>
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
        <div id="createdialog" style="display:none;">
            <div id="createDialogErrorPane" style="display:none;" class="warning"></div>
            <table>
                <tr>
                    <td>
                        <label for="name">Isim</label>
                    </td>
                    <td>
                        <input type="text" id="createname" name="name" required="true"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <label for="surname">Soyisim</label>                        
                    </td>
                    <td>
                        <input type="text" id="createsurname" name="surname" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="telNo">Telefon</label>
                    </td>
                    <td>
                        <input type="text" id="createtelNo" name="telNo" onkeyup="this.value = this.value.replace(/^(\d{3})(\d{3})(\d{2})(\d{2})$/, '($1) $2 $3 $4')"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="captcha">Captcha</label>
                    </td>
                    <td>
                        <input type="text" id="captcha" name="captcha" required="true"/>
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
        <div id="updatedialog" style="display:none;">
            <div id="updateDialogErrorPane" style="display:none;" class="warning"></div>
            <table>
                <tr>
                    <td>
                        <label for="name">Isim</label>
                    </td>
                    <td>
                        <input type="hidden" id="userId" name="userId"/>
                        <input type="text" id="updatename" name="name" required="true"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <label for="surname">Soyisim</label>                        
                    </td>
                    <td>
                        <input type="text" id="updatesurname" name="surname" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="telNo">Telefon</label>
                    </td>
                    <td>
                        <input type="text" id="updatetelNo" name="telNo" onkeyup="this.value = this.value.replace(/^(\d{3})(\d{3})(\d{2})(\d{2})$/, '($1) $2 $3 $4')"/>
                    </td>
                </tr>
            </table>
        </div>
        <div id="deleteconfirm" title="Kullanici Silme" style="display:none;">
            <p></span>Kullaniciyi silmek istediginizden emin misiniz?</p>
        </div>
        <div class="loader"></div>
        <!--div id="wait" style="display:none;width:105px;height:150px;border:1px solid black;position:absolute;top:50%;left:50%;padding:2px;"><img src='<c:url value="resources/img/ajax-loader1.gif" />' width="100" height="100" /><br>Loading..</div-->
    </center>  
</body>  
</html> 
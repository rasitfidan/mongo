<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale value='tr_TR'/>
<fmt:setBundle basename='com.infonal.resource.App'/>

<html>  
<head>  
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    
    <link rel="stylesheet" href="<c:url value="resources/css/jquery-ui.css" />">
    <link rel="stylesheet" href="<c:url value="resources/css/style.css" />">
    <script type="text/javascript" src="<c:url value="resources/js/jquery.js" />"></script>
    <script type="text/javascript" src="<c:url value="resources/js/jquery-ui.js" />"></script>

    <title><fmt:message key='user.title'/></title>  
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
                cache: false,
                type: "GET",
                dataType: "json",
                url: "user/list?"+Math.random(),
                success: function (reqResult) {
                    decorateUserTable(reqResult);
                }
            });
        }

        function decorateUserTable(reqResult) {
            if(reqResult.successfull){
                var userResultList = reqResult.resultList;

                var uTable = document.getElementById("userTable");
                //Onceki tablo datayi sil. 0. satiri silmiyoruz cunku o satir header satiri
                for(var j=1;j<uTable.rows.length;){
                    uTable.deleteRow(1);
                }
                
                for(var i=0 ; i<userResultList.length; i++){
                    var user = userResultList[i];

                    var tRow = uTable.insertRow(uTable.rows.length);

                    var cell1 = tRow.insertCell(0);
                    var cell2 = tRow.insertCell(1);
                    var cell3 = tRow.insertCell(2);
                    var cell4 = tRow.insertCell(3);
                    var cell5 = tRow.insertCell(4);
                    
                    cell1.innerHTML = user.name;
                    cell2.innerHTML = user.surname;
                    cell3.innerHTML = user.telNo;
                    cell4.innerHTML = "<input type=\"image\" src=\"resources/img/edit.png\" onclick=\"newOrUpdateUserPopupOpen('"+user.id+"','"+user.name+"','"+user.surname+"','"+user.telNo+"');\" width=\"30\" height=\"30\"/>";
                    cell5.innerHTML = "<input type=\"image\" src=\"resources/img/delete.png\" onclick=\"deleteUser('"+user.id+"');\" width=\"25\" height=\"25\"/>";
                }
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
                winTitle = $('#updatedialogtitle').val();
                
                dialogType = "update";
                
                height = 270;
            } else {
                action = "user/create";
                winTitle = $('#createdialogtitle').val();
                
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
                    "<fmt:message key='user.savebuttonlabel'/>": function() {      
                        m_name = $('#'+dialogType+'name').val();
                        m_surname = $('#'+dialogType+'surname').val();
                        m_telNo = $('#'+dialogType+'telNo').val();

                        m_captcha = $('#captcha').val();

                       var errorMessages = "";

                       if(m_name==="") {
                          errorMessages+="<li><fmt:message key='user.page.nameLabel'/></li>"; 
                       }

                       if(m_surname==="") {
                          errorMessages+="<li><fmt:message key='user.page.surnameLabel'/></li>"; 
                       }

                       if(m_captcha==="" && (m_id===null || m_id ==="")) {
                          errorMessages+="<li><fmt:message key='user.dialog.captchaLabel'/></li>"; 
                       }

                       if(errorMessages!==""){
                            var dialogErrPane = $( dialogErrorPaneName );

                            dialogErrPane.html("<p><fmt:message key='user.dialog.errorPaneMandatoryFields'/></p>" +
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
                    "Iptal" : function() {
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
            var cancelbuttonlabel = $( "#cancelbuttonlabel").val();
            
            $( "#deleteconfirm" ).dialog({
                resizable: false,
                height:200,
                width: 450,
                modal: true,
                title: $('#deletedialogtitle').val(),
                buttons: {
                    "<fmt:message key='user.deletedialog.yesbuttonlabel'/>": function() {
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
                    "Iptal" : function() {
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
    <!--jquery window title gecerken utf8 encoding sacmaliyor-->
    <input type="hidden" id="createdialogtitle" name="createdialogtitle" value="<fmt:message key='user.createdialog.title'/>"/>
    <input type="hidden" id="updatedialogtitle" name="updatedialogtitle" value="<fmt:message key='user.updatedialog.title'/>"/>
    <input type="hidden" id="deletedialogtitle" name="deletedialogtitle" value="<fmt:message key='user.deletedialog.title'/>"/>
    
    <center>  
        <div id="userListDiv">
            <table>
                <caption><fmt:message key='user.pagetitle'/></caption>
                <tr>            
                    <td>    
                        <table id="userTable">
                             <thead>
                                <tr>
                                   <th><fmt:message key='user.page.nameLabel.upper'/></th>
                                   <th><fmt:message key='user.page.surnameLabel.upper'/></th>
                                   <th><fmt:message key='user.page.phoneLabel'/></th>
                                   <th></th>
                                   <th></th>
                                </tr>
                             </thead>
                             <tbody>
                               <tr>
                                   <td></td>
                                   <td></td>
                                   <td></td>
                                   <td></td>
                                   <td></td>
                                </tr>
                             </tbody>
                        </table>
                    <td>
                </tr>
                <tr>            
                    <td>
                        <button onclick="newOrUpdateUserPopupOpen(null,null,null,null)"><fmt:message key='user.action.newuserLabel'/></button> 
                    <td>
                </tr>            
            </table>
        </div>
        <div id="createdialog" style="display:none;">
            <div id="createDialogErrorPane" style="display:none;" class="warning"></div>
            <table>
                <tr>
                    <td>
                        <label for="name"><fmt:message key='user.page.nameLabel'/></label>
                    </td>
                    <td>
                        <input type="text" id="createname" name="name" required="true"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <label for="surname"><fmt:message key='user.page.surnameLabel'/></label>                        
                    </td>
                    <td>
                        <input type="text" id="createsurname" name="surname" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="telNo"><fmt:message key='user.page.phoneLabel'/></label>
                    </td>
                    <td>
                        <input type="text" id="createtelNo" name="telNo" onkeyup="this.value = this.value.replace(/^(\d{3})(\d{3})(\d{2})(\d{2})$/, '($1) $2 $3 $4')"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="captcha"><fmt:message key='user.dialog.captchaLabel'/></label>
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
                        <label for="name"><fmt:message key='user.page.nameLabel'/></label>
                    </td>
                    <td>
                        <input type="hidden" id="userId" name="userId"/>
                        <input type="text" id="updatename" name="name" required="true"/>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <label for="surname"><fmt:message key='user.page.surnameLabel'/></label>                        
                    </td>
                    <td>
                        <input type="text" id="updatesurname" name="surname" required="true"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="telNo"><fmt:message key='user.page.phoneLabel'/></label>
                    </td>
                    <td>
                        <input type="text" id="updatetelNo" name="telNo" onkeyup="this.value = this.value.replace(/^(\d{3})(\d{3})(\d{2})(\d{2})$/, '($1) $2 $3 $4')"/>
                    </td>
                </tr>
            </table>
        </div>
        <div id="deleteconfirm" title="<fmt:message key='user.deletedialog.title'/>" style="display:none;">
            <p></span><fmt:message key='user.deletedialog.sure'/></p>
        </div>
        <div class="loader"></div>
        <!--div id="wait" style="display:none;width:105px;height:150px;border:1px solid black;position:absolute;top:50%;left:50%;padding:2px;"><img src='<c:url value="resources/img/ajax-loader1.gif" />' width="100" height="100" /><br>Loading..</div-->
    </center>  
</body>  
</html> 
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<script>
var naverLogin = new naver.LoginWithNaverId({
       	clientId : "CLgmNZMbjGe7TApfTPy_",
     	callbackUrl : "http://localhost:8080/spring/naverLoginRedirect.jsp",
          	isPopup: true,
          	callbackHandle: true
          /* callback 페이지가 분리되었을 경우에 callback 페이지에서는 callback처리를 해줄수 있도록 설정합니다. */
});
 /* (3) 네아로 로그인 정보를 초기화하기 위하여 init을 호출 */
naverLogin.init();
 
 /* (4) Callback의 처리. 정상적으로 Callback 처리가 완료될 경우 main page로 redirect(또는 Popup close) */
 window.addEventListener('load', function () {
   		naverLogin.getLoginStatus(function (status) {
		console.log(status);
    	 if (status){
           /* (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 */
           console.log(naverLogin.user);
           var email = naverLogin.user.getEmail();
           var name = naverLogin.user.getNickName();
           var profileImage = naverLogin.user.getProfileImage();
           var unqId = naverLogin.user.getId();
           if( email == undefined || email == null || name == undefined || name == null) {
              alert("이메일과 이름은 필수정보입니다. 정보제공을 동의해주세요.");
              /* (5-1) 사용자 정보 재동의를 위하여 다시 네아로 동의페이지로 이동함 */
              naverLogin.reprompt();
              return;
           }
           /* alert(naverLogin.user);
           alert(email+"/" + name + "/" + unqId); */
           window.opener.loginWithNaver(email, name, profileImage, unqId);
           window.close();
           /* window.location.replace("http://" + window.location.hostname + ( (location.port==""||location.port==undefined)?"":":" + location.port) + "/spring/main.dr"); */
		} else {
		           console.log("이메일 : " + email);
		           console.log("이름 : " + name);
		           console.log("아이디 : " + unqId);
		}
	 });
 
});
	


</script>

</body>
</html>
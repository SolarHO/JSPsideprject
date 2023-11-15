<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="css/bootstrap.css" rel="stylesheet">
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=6sx49ht4ta&submodules=geocoder"></script>
<title>Insert title here</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>
  <nav class="navbar navbar-default">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="main.jsp">대동여지도</a>
    </div>
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class="active"><a href="main.jsp">메인</a></li>
        <li><a href="bbs.jsp">게시판</a></li>
      </ul>
      <%
      	if(userID == null) {
      %>
      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="login.jsp">로그인</a></li><!-- 현재 선택된 메뉴 -->
            <li><a href="join.jsp">회원가입</a></li>
          </ul>
        </li>
      </ul>
      <%
      	} else {
      %>
      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="logoutAction.jsp">로그아웃</a></li>
          </ul>
        </li>
      </ul>
      <%		
      	}
      %>
    </div>
  	</nav>
  	<div class="container">
        <div class="row">
            <div class="col-md-8">
                <!-- 테이블 영역 -->
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr>
                            <th style="background-color: #eeeeee; text-align: center;">번호</th>
                            <th style="background-color: #eeeeee; text-align: center;">제목</th>
                            <th style="background-color: #eeeeee; text-align: center;">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>ㅇㅇ</td>
                            <td>2023-11-13</td>
                        </tr>
                        <!-- 다른 게시물에 대한 행들을 추가할 수 있습니다 -->
                    </tbody>
                </table>
                <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
            </div>
            <div class="col-md-4">
                <!-- 지도 영역 -->
                <div id="map" style="width: 100%; height: 400px;"></div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // 지도 초기화
            var mapOptions = {
                center: new naver.maps.LatLng(36.678308, 127.991150), // 초기 중심 위치 (서울)
                zoom: 3, // 초기 줌 레벨
                mapTypeId: naver.maps.MapTypeId.SATELLITE
            };
            var map = new naver.maps.Map('map', mapOptions);

            // 마커 추가 및 정보 창 예제
            var marker = new naver.maps.Marker({
                position: new naver.maps.LatLng(37.5665, 126.9780),
                map: map
            });

            var infoWindow = new naver.maps.InfoWindow({
                content: '<h2>마커 정보</h2><p>이곳은 지도상의 마커입니다.</p>'
            });
            naver.maps.Event.addListener(marker, 'click', function(e) {
                infoWindow.open(map, marker);
            });
        });
    </script>
</body>
</html>
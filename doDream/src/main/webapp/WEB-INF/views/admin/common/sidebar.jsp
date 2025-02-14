<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<!-- Sidebar -->
	<ul
		class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
		id="accordionSidebar">

		<!-- Sidebar - Brand -->
		<a
			class="sidebar-brand d-flex align-items-center justify-content-center"
			href="main.dr">
			<div class="sidebar-brand-icon rotate-n-15" style="color: #FFCD01;">
				<i class="fas fa-laugh-wink"></i>
			</div>
			<div class="sidebar-brand-text mx-3">두 드 림</div>
		</a>

		<!-- Divider -->
		<hr class="sidebar-divider my-0">

		<!-- Nav Item - Dashboard -->
		<li class="nav-item active"><a class="nav-link"
			href="adminHome.dr"> <i class="fas fa-fw fa-tachometer-alt"></i>
				<span>메 인</span></a></li>

		<!-- Divider -->
		<hr class="sidebar-divider">

		<!-- Heading -->
		<div class="sidebar-heading">관리</div>

		<!-- Nav Item - Pages Collapse Menu -->
		<li class="nav-item"><a class="nav-link collapsed" href="#"
			data-toggle="collapse" data-target="#dropDown1" aria-expanded="true"
			aria-controls="dropDown1"> <i class="fas fa-fw fa-cog"></i> <span>회원
					관리 </span>
		</a>
			<div id="dropDown1" class="collapse" aria-labelledby="headingTwo"
				data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="adminMlist.dr"><p>〉 일반회원 관리</p></a>
					<a class="collapse-item" href="adminBlist.dr"><p>〉 블랙리스트 관리</p></a>
				</div>
			</div></li>

		<li class="nav-item"><a class="nav-link collapsed" href="#"
			data-toggle="collapse" data-target="#dropDown2" aria-expanded="true"
			aria-controls="dropDown2"> <i class="fas fa-fw fa-cog"></i> <span>프로젝트
					관리 </span>
		</a>
			<div id="dropDown2" class="collapse" aria-labelledby="headingTwo"
				data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="adminPlist1.dr"><p>〉 심사 대기 프로젝트</p></a>
					<a class="collapse-item" href="adminPlist2.dr"><p>〉 심사 완료 프로젝트</p></a> <a
						class="collapse-item" href="adminPlist3.dr"><p>〉 오픈 중인 프로젝트</p></a> <a
						class="collapse-item" href="adminPlist4.dr"><p>〉 마감된 프로젝트</p></a>
				</div>
			</div></li>

		<li class="nav-item"><a class="nav-link collapsed" href="#"
			data-toggle="collapse" data-target="#dropDown3" aria-expanded="true"
			aria-controls="dropDown3"> <i class="fas fa-fw fa-cog"></i> <span>결제
					관리</span>
		</a>
			<div id="dropDown3" class="collapse" aria-labelledby="headingTwo"
				data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="adminRlist4.dr"><p>〉 성공 펀딩 현황</p></a> 
					<a class="collapse-item" href="adminRlist1.dr"><p>〉 주문 예약 현황</p></a> 
					<a class="collapse-item" href="adminRlist2.dr"><p>〉 결제 완료 현황</p></a> 
					<a class="collapse-item" href="adminRlist3.dr"><p>〉 주문 취소 현황</p></a>
				</div>
			</div></li>

		<li class="nav-item"><a class="nav-link collapsed" href="#"
			data-toggle="collapse" data-target="#dropDown4" aria-expanded="true"
			aria-controls="dropDown4"> <i class="fas fa-fw fa-cog"></i> <span>신고
					관리</span>
		</a>
			<div id="dropDown4" class="collapse" aria-labelledby="headingTwo"
				data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="adminReplist.dr"><p>〉 신고 접수 현황</p></a>
					<a class="collapse-item" href="adminRepRlist.dr"><p>〉 신고 답변 현황</p></a>
				</div>
			</div></li>

		<li class="nav-item"><a class="nav-link collapsed" href="#"
			data-toggle="collapse" data-target="#dropDown5" aria-expanded="true"
			aria-controls="dropDown5"> <i class="fas fa-fw fa-cog"></i> <span>게시판
					관리</span>
		</a>
			<div id="dropDown5" class="collapse" aria-labelledby="headingTwo"
				data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="adminNoticeList.dr"><p>〉 공지사항</p></a> <a
						class="collapse-item" href="adminReviewList.dr"><p>〉 프로젝트 후기</p></a> <a
						class="collapse-item" href="adminReplyList.dr"><p>〉 댓글 관리</p></a><a
						class="collapse-item" href="adminFaqList.dr"><p>〉 FAQ 관리</p></a>
				</div>
			</div></li>


		<!-- Divider -->
		<hr class="sidebar-divider">


		<!-- Sidebar Toggler (Sidebar) -->
		<div class="text-center d-none d-md-inline">
			<button class="rounded-circle border-0" id="sidebarToggle"></button>
		</div>

	</ul>
	<!-- End of Sidebar -->

</body>
</html>
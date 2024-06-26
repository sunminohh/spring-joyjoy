<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/myheader.jsp"%>

<style>
    .table th:nth-child(2),
    .table td:nth-child(2) {
        width: 40%; /* 제목 칸 너비 조절 */
    }
    
     /* 기본 페이지 버튼 스타일 */
    .paginate_button a {
        color: red; /* 페이지 버튼의 기본 텍스트 색상 */
    }
    /* 활성 페이지 버튼에 대한 스타일 */
    .paginate_button.active {
        background-color: red; /* 활성 페이지 버튼의 배경색을 빨간색으로 변경 */
    }
    /* 활성 페이지 버튼 텍스트에 대한 스타일 */
    .paginate_button.active a {
        color: white; /* 활성 페이지 버튼의 텍스트 색상을 하얀색으로 변경 */
    }
</style>

<!--Register Modal -->
 <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
     <div class="modal-dialog">
         <div class="modal-content bg-secondary text-white">
             <div class="modal-header">
                 <h4 class="modal-title text-white" id="myModalLabel">Success</h4>
             </div>
             <div class="modal-body">
           		처리가 완료되었습니다.
             </div>
             <div class="modal-footer">
             	<button id='modalCloseBtn' type="button" class ="btn btn-light" data-bs-dismiss="modal" aria-label="Close">Close</button>
             </div>
         </div>
         <!-- /.modal-content -->
     </div>
     <!-- /.modal-dialog -->
 </div>


<!-- Table Start -->
<div class="container-fluid pt-4 px-4">
	<div class="row g-4">

		<div class="col-12">
			<div class="bg-secondary rounded h-100 p-4">
				<div class="d-flex justify-content-between align-items-center mb-4">
					<h4 class="mb-0">My Reply</h4>

				</div>

				<div class="table-responsive">

					<table class="table">
						<thead>
							<tr>
								<th scope="col">#게시판</th>
								<th scope="col" style="text-align: center;">댓글</th>
								<th scope="col" style="text-align: center;">작성일</th>
								<th scope="col" style="text-align: center;">수정일</th>
							</tr>
						</thead>
						<c:choose>
							<c:when test="${empty replyList }">
								<tr>
									<td colspan="4" style="text-align: center;">검색 결과가 없습니다.</td>
								</tr>
							</c:when>

							<c:otherwise>
								<c:forEach items="${replyList }" var="reply">
									<tr>
										<td><c:out value="${reply.type }" /></td>
										<td>
										    <c:choose>
										        <c:when test="${reply.type eq 'Movie'}">
										            <a class='move' data-type='movie' href='<c:out value="${reply.bno }"/>'>
										                <c:out value="${reply.reply}" /> 
										            </a>
										        </c:when>
										        <c:when test="${reply.type eq 'Game'}">
										            <a class='move' data-type='game' href='<c:out value="${reply.bno }"/>'>
										                <c:out value="${reply.reply}" /> 
										            </a>
										        </c:when>
										        <c:when test="${reply.type eq 'Book'}">
										            <a class='move' data-type='book' href='<c:out value="${reply.bno }"/>'>
										                <c:out value="${reply.reply}" /> 
										            </a>
										        </c:when>
										        <c:when test="${reply.type eq 'Etc'}">
										            <a class='move' data-type='etc' href='<c:out value="${reply.bno }"/>'>
										                <c:out value="${reply.reply}" /> 
										            </a>
										        </c:when>
										    </c:choose>
										</td>
										<td style="text-align: center;"><fmt:formatDate pattern="yyyy-MM-dd"
												value="${reply.replyDate }" /></td>
										<td style="text-align: center;"><fmt:formatDate pattern="yyyy-MM-dd"
												value="${reply.updateDate }" /></td>
									</tr>
								</c:forEach> 
							</c:otherwise> 
						</c:choose>	
					</table>
				</div>

				<div class='row'>
					<div class="col-lg-12">
						<form id='searchForm' action="/user/myreply" method='get'>
							<select name='type'>
								<option value=""
									<c:out value="${pageMaker.page.type == null ? 'selected' : ''}" />>검색
									조건을 선택해주세요.</option>
								<option value="T"
									<c:out value="${pageMaker.page.type eq 'P' ? 'selected' : ''}" />>게시판</option>
								<option value="C"
									<c:out value="${pageMaker.page.type eq 'C' ? 'selected' : ''}" />>댓글</option>
								<option value="TC"
									<c:out value="${pageMaker.page.type eq 'TP' ? 'selected' : ''}" />>게시판 or 댓글</option>
							</select> 
							<input type='text' name='keyword'
								value='<c:out value="${pageMaker.page.keyword}"/>' /> 
							<input type='hidden' name='pageNum'
								value='<c:out value="${pageMaker.page.pageNum}"/>' /> 
							<input type='hidden' name='amount'
								value='<c:out value="${pageMaker.page.amount}"/>' />
							 <input type="hidden" name="userid" value="${pageContext.request.userPrincipal.name}" />
							<button class='btn btn-primary btn-sm'>Search</button>
						</form>
					</div>
				</div>

				<div class='btn-toolbar float-end' role='toolbar'>
					<ul class="pagination btn-group me-2" role='group'>
						<c:if test="${pageMaker.prev}">
							<li class="paginate_button previous btn btn-secondary"><a
								href="${pageMaker.startPage-1 }">Previous</a></li>
						</c:if>
						<c:forEach var="num" begin="${pageMaker.startPage}"
							end="${pageMaker.endPage }">
							<li
								class="paginate_button btn btn-secondary ${pageMaker.page.pageNum == num ? "active": ""}">
								<a href="${num }">${num }</a>
							</li>
						</c:forEach>
						<c:if test="${pageMaker.next}">
							<li class="paginate_button next btn btn-secondary"><a
								href="${pageMaker.endPage + 1 }">Next</a></li>
						</c:if>
					</ul>
					<form id="actionForm" action="/user/myreply" method="get">
						<input type="hidden" name="pageNum" value="${pageMaker.page.pageNum }"> <input type="hidden"
							name="amount" value="${pageMaker.page.amount }"> 
						<input type="hidden" name="type"
							value='<c:out value="${pageMaker.page.type }"/>'> 
						<input type="hidden" name="keyword"
							value='<c:out value="${pageMaker.page.keyword }"/>'>
						<input type="hidden" name="userid" value="${pageContext.request.userPrincipal.name}" />
					</form>
				</div>



			</div>
		</div>
	</div>
</div>
<!-- Table End -->


<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
	    let profileLinks = document.querySelectorAll('.navbar-nav a');
	    profileLinks.forEach(function(link) {
	        if (link.getAttribute('href').startsWith("/user/myreply")) {
	            link.classList.add('active');
	        }
	    });
	});
	
	$(document)
			.ready(
					function() {

						let result = '<c:out value="${result}" />';

						checkModal(result);

						history.replaceState({}, null, null);

						function checkModal(reesult) {
							if (result == '' || history.state) {
								return;
							}

							if (parseInt(result) > 0) {
								$(".modal-body").html(
										"게시글 " + parseInt(result)
												+ "번이 등록되었습니다.");
							}

							$("#myModal").modal("show");
						}

						let actionForm = $("#actionForm");

						$(".paginate_button a").on(
								"click",
								function(e) {
									e.preventDefault();

									console.log('click');

									actionForm.find("input[name='pageNum']")
											.val($(this).attr("href"));
									actionForm.submit();
								});
						
						$(".move").on("click", function(e) {
						    e.preventDefault();
						    let type = $(this).data("type");
						    let actionUrl;

						    if (type === "movie") {
						        actionUrl = "/movie/detail";
						    } else if (type === "game") {
						        actionUrl = "/game/detail";
						    } else if (type === "book") {
						        actionUrl = "/book/detail";
						    } else if (type === "etc") {
						        actionUrl = "/etc/detail";
						    } else {
						        console.error("Unknown type: " + type);
						        return;
						    }

						    actionForm
							.append("<input type='hidden' name='bno' value='"
									+ $(this).attr(
											"href")
									+ "'>");
						    actionForm.attr("action", actionUrl);
						    actionForm.submit();
						}); 



						let searchForm = $("#searchForm");

						$("#searchForm button").on(
								"click",
								function(e) {

									if (!searchForm.find("option:selected")
											.val()) {
										alert("검색종류를 선택하세요.");
										return false;
									}

									if (!searchForm.find(
											"input[name='keyword']").val()) {
										alert("키워드를 입력하세요.");
										return false;
									}

									searchForm.find("input[name='pageNum']").val("1");
									e.preventDefault();

									searchForm.submit();
								});

					});
</script>

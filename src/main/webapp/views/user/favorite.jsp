<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Yêu thích</title>
	<%@include file="/common/head.jsp"%>
</head>

<body>
	<header>
		<%@include file="/common/header.jsp"%>
	</header>
	<main>
		<div class="container-fluid tm-container-content mt-3">
			<div class="row mb-4">
				<h2 class="col-6 tm-text-primary m-0">Video đã thích</h2>
				<div class="col-6 d-flex justify-content-end align-items-center">
					<form action="" class="tm-text-primary">
						Trang <input type="text" value="1" size="1" class="tm-input-paging tm-text-primary">
						trên 180
					</form>
				</div>
			</div>
			<div class="row tm-gallery">
				<c:forEach items="${videos}" var="video">
					<div class="favorite-list-item col-xl-3 col-lg-4 col-md-6 col-sm-6 col-12 mb-5">
						<div class="position-relative video-item">
							<figure class="effect-ming tm-video-item mb-2">
								<img src="${video.poster}" alt="thumbnail" class="img-fluid">
								<figcaption class="d-flex align-items-center justify-content-center">
									<h2 class="fs-1">
										<i class="fa-solid fa-circle"></i>
									</h2>
								</figcaption>
							</figure>

							<h5 class="tm-text-secondary">
								<a href="${urlVideo}?action=watch&id=${video.id}"
									class="stretched-link d-block text-truncate">${video.title}</a>
							</h5>
						</div>
						<div class="d-flex justify-content-between align-items-center tm-text-gray">
							<div>
								<fmt:formatDate value="${video.uploadDate}" pattern="dd-MM-yyyy" /> - ${video.views} lượt xem
							</div>
							<div class="icon-group">
								<a class="icon-like link-secondary fs-4" data-user-id="${video.id}">
									<i data-bs-toggle="tooltip" data-bs-placement="top" title="Bỏ thích video này" class="icon fas fa-thumbs-down"></i>
								</a>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</main>
	<footer>
		<%@include file="/common/footer.jsp"%>
	</footer>
	<script>
		$('.icon-like').click(function () {
			var videoId = $(this).attr('data-user-id');
			var favoriteItemElement = $(this).parents('.favorite-list-item');
			$.ajax({
				url: 'video?action=like&id=' + videoId,
				type: 'GET',
				success: function (response) {
					$(favoriteItemElement).remove();
				},
				error: function (xhr) {
					alert("Có lôi xảy ra! Không thể thực hiện thao tác!");
				}
			});
		});
	</script>
</body>

</html>
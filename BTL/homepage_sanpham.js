var app = angular.module('AppBanSach', []);
app.filter('addLineBreaks', function() {
    return function(input) {
      if (!input) return input;

      // Chia chuỗi thành các từ
      var words = input.split(' ');

      // Thêm dấu xuống dòng sau mỗi 2 từ
      for (var i = 1; i < words.length; i += 2) {
        words[i] += '\n';
      }

      // Kết hợp lại thành chuỗi mới
      return words.join(' ');
      
    };
  })
app.controller("HomeCtrl", function ($scope,$http) {
    $scope.listCategory;
    $scope.listAllCategory;
    $scope.listItem;
    $scope.listBill;
    $scope.GetSach = function () {
        $http({
            method: 'POST',
            data: {page: 1, pageSize: 10},
            url: current_url + '/api-admin/sach/search',
        }).then(function (response) {
            debugger;
            $scope.listItem = response.data.data;
        });
    };
    $scope.GetSach();
    $scope.GetCategory = function () {
        $http({
            method: 'POST',
            data: {page: 1, pageSize: 10},
            url: current_url + '/api-admin/LoaiSach/search',
        }).then(function (response) {
            debugger;
            $scope.listCategory = response.data.data;
        });
    };
    $scope.GetCategory();
    $scope.GetAllCategory = function () {
        $http({
            method: 'POST',
            data: {page: 1, pageSize: 10},
            url: current_url + '/api-admin/LoaiSach/search',
        }).then(function (response) {
            debugger;
            $scope.listAllCategory = response.data.data;
        });
    };
    $scope.GetAllCategory();
    $scope.Login = function () {		
		var loginForm = new FormData();
		loginForm.append("Taikhoan", $("#tailkhoan").val());
		loginForm.append("Matkhau", $("#matkhau").val());  
        $.ajax({
            type: "POST",
            url: "http://localhost:41308/api/login",
            processData: false,
			contentType: false,
            data: loginForm
        }).done(function (data) {         
            if (data != null && data.message != null && data.message != 'undefined') {
                alert(data.message);
            } else {
                localStorage.setItem("user", JSON.stringify(data));                    window.location.href = "sanpham.html";
            }   
        }).fail(function() {
            alert('Có lỗi');
        }); 
    };

    $scope.GetBill = function() {
        $http({
            method: 'POST',
            data: {page: 1, pageSize: 10},
            url: current_url + '/api-admin/HoaDon/search',
        }).then(function (response) {
            debugger;
            $scope.listBill = response.data.data;
        });
    };
    $scope.GetBill();
});
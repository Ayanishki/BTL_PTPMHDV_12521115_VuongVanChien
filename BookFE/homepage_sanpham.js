var app = angular.module('AppBanSach', []);
app.filter('addLineBreaks', function () {
    return function (input) {
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
app.controller("HomeCtrl", function ($scope, $http) {
    $scope.listCategory;
    $scope.listAllCategory;
    $scope.listItem;
    $scope.listBill;
    $scope.GetSach = function () {
        $http({
            method: 'POST',
            data: { page: 1, pageSize: 10 },
            url: current_url + '/api-admin/sach/search',
        }).then(function (response) {
            debugger;
            $scope.listItem = response.data.data;
        });
    };
    $scope.GetSach();
    // $scope.GetCategory = function () {
    //     $http({
    //         method: 'POST',
    //         data: { page: 1, pageSize: 10 },
    //         url: current_url + '/api-admin/LoaiSach/search',
    //     }).then(function (response) {
    //         debugger;
    //         changeimg($scope)
    //         $scope.listCategory = response.data.data;
    //     });
    // };
    // $scope.GetCategory();
    $scope.GetAllCategory = function () {
        $http({
            method: 'POST',
            data: { page: 0, pageSize: 0 },
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
                localStorage.setItem("user", JSON.stringify(data)); window.location.href = "sanpham.html";
            }
        }).fail(function () {
            alert('Có lỗi');
        });
    };
    $scope.GetBill = function () {
        $http({
            method: 'POST',
            data: { page: 1, pageSize: 10 },
            url: current_url + '/api-admin/HoaDon/search',
        }).then(function (response) {
            debugger;
            $scope.listBill = response.data.data;
        });
    };
    $scope.GetBill();
    $scope.newProduct = {
        maSach: '',
        maLoai: '3',
        tenSach: 'chien',
        gia: 3,
        soLuong: 3,
        tacGia: '3',
        bookCover: 'Unknown'
    };
    // $scope.updateCategory = function() {
    //     // Lấy giá trị thực sự từ data-value tương ứng với giá trị đã chọn
    //     var selectedValue = $scope.newProduct.selectedCategory;

    //     // Tìm tùy chọn tương ứng trong danh sách
    //     var selectedTenLoai = $scope.maLoai.find(function(x) {
    //         return x.value === selectedValue;
    //     });

    //     // Cập nhật giá trị muốn gửi lên server
    //     $scope.newProduct.maLoai = selectedTenLoai ? selectedTenLoai.dataValue : '';
    // };
    $scope.imageChanged = function (element) {
        $scope.$apply(function () {
            $scope.newProduct.image = element.files[0];
        });
    };
    $scope.image = null;

    $scope.handleImageChange = function (input) {
        var file = input.files[0];

        if (file) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $scope.$apply(function () {
                    $scope.image = e.target.result;
                });
            };
            reader.readAsDataURL(file);
        }
    };
    $scope.ApiThemSach = function () {
        var item = {};
        item.maSach = $scope.newProduct.maLoai;
        item.maLoai = $scope.newProduct.maLoai;
        item.tenSach = $scope.newProduct.tenSach;
        item.gia = $scope.newProduct.gia;
        item.soLuong = $scope.newProduct.soLuong;
        item.tacGia = $scope.newProduct.tacGia;
        item.bookCover = $scope.image;

        var formData = new FormData();
        formData.append('maLoai', $scope.newProduct.maLoai);
        formData.append('maLoai', $scope.newProduct.maLoai);
        formData.append('tenSach', $scope.newProduct.tenSach);
        formData.append('gia', $scope.newProduct.gia);
        formData.append('soLuong', $scope.newProduct.soLuong);
        formData.append('tacGia', $scope.newProduct.tacGia);
        formData.append('bookCover', $scope.image);
        $http({
            method: 'POST',
            data: {
                maLoai: $scope.newProduct.maLoai,
                tenSach: $scope.newProduct.tenSach,
                gia: $scope.newProduct.gia,
                soLuong: $scope.newProduct.soLuong,
                tacGia: $scope.newProduct.tacGia,
                bookCover: $scope.image
            },

            url: current_url + '/api-admin/Sach/create-sach',
            // headers: { 'Content-Type': undefined}, // Báo cho server biết đây là dữ liệu form
        }).then(function (response) {
            console.log('Sach đã được thêm thành công!', response.data);
            alert('Sach đã được thêm thành công');
            $scope.GetSach();
            $scope.GetAllCategory();
            // Xử lý kết quả nếu cần
        }, function (error) {
            console.error('Có lỗi xảy ra khi thêm sản phẩm:', error);
            // Xử lý lỗi nếu cần
            alert('Có lỗi xảy ra khi thêm sản phẩm');
        });
        
    };
    $scope.ApiXoaSach = function (ma) {
        $http({
            method: 'DELETE',
            url: current_url + '/api-admin/Sach/delete-sach?model=' + ma,
            // headers: { 'Content-Type': underfied }, // Báo cho server biết đây là dữ liệu form
            // // transformRequest: angular.identity
        }).then(function (response) {
            console.log('Sach đã được xóa thành công!', response.data);
            alert('Sach đã được xóa thành công công');
            // Xử lý kết quả nếu cần
            $scope.GetSach();
            $scope.GetAllCategory();
        }, function (error) {
            console.error('Có lỗi xảy ra khi xóa sản phẩm:', error);
            // Xử lý lỗi nếu cần
            alert('Có lỗi xảy ra khi xóa sản phẩm');
        });
    };
    $scope.ApiSuaSach = function (ma) {
        $http({
            method: 'POST',
            data: {
                maSach: ma,
                maLoai: $scope.newProduct.maLoai,
                tenSach: $scope.newProduct.tenSach,
                gia: $scope.newProduct.gia,
                soLuong: $scope.newProduct.soLuong,
                tacGia: $scope.newProduct.tacGia,
                bookCover: $scope.newProduct.bookCover,
            },
            url: current_url + '/api-admin/Sach/update-sach'
        }).then(function (response) {
            console.log('Sach đã được sửa thành công!', response.data);
            alert('Sach đã được sửa thành công');
            // Xử lý kết quả nếu cần
            $scope.GetSach();
            $scope.GetAllCategory();
        }, function (error) {
            console.error('Có lỗi xảy ra khi sửa sản phẩm:', error);
            // Xử lý lỗi nếu cần
            alert('Có lỗi xảy ra khi sửa sản phẩm');
        });
    }
    $scope.selectRow = function (item) {
        // Copy the data of the selected item to newProduct
        $scope.newProduct = angular.copy(item);
    };
    $scope.Login = function(){
        var item = {};
        item.username = document.getElementById('txtusername').value;
        item.password = document.getElementById('txtpassword').value;

        $http({
            method: 'POST',
            url: current_url + '/api-admin/user/login',
            data: item,
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(
            function(response) {
                var data = response.data;
                if (data != null && data.message != null && data.message != 'undefined') {
                    alert(data.message);
                }
                else{
                    localStorage.setItem('Token', data.token);
                    if(data.roles == 1){
                        window.location.href = "Quanlysach.html";
                    }
                    else if(data.roles == 2){
                        window.location.href = "index.html";
                    }
                }
            }
            // ,
            // function() {
            //     checkUsser();
            // }
        )
     };
    // $scope.DataBiding = function () {
    //     $scope.newProduct = {}; // Object to store data for input fields

    //     $scope.selectRow = function(item) {
    //     // Copy the data of the selected item to newProduct
    //         $scope.newProduct = angular.copy(item);
    //     };
    // };

    // $scope.UploadImageFile = function(file) {
    //     var formData = new FormData();
    //     formData.append('file', file);

    //     $http({
    //         method: "POST",
    //         url: current_url + '/api-admin/OtherTools/upload-images',
    //         data: formData,
    //         headers: {
    //             'Content-Type': undefined
    //         }
    //     })
    //     .then(
    //         function(response) {
    //             var data = response.data;
    //             if (data != null && data.message != null && data.message != 'undefined') {
    //                 alert(data.message);
    //             } else {
    //                 $scope.image = data.fullPath;
    //             }
    //         }
    //     );
    // }
    // function changeimg($scope){
    //     $$('td .file_img').forEach(function(input, index){
    //       input.addEventListener('change', function(event){
    //         const imgElement = $$('td .img')[index];
    //         const fileInput = event.target;

    //         if (fileInput.files && fileInput.files[0]) {
    //           const reader = new FileReader();
    //           reader.onload = function(e) {
    //             imgElement.src = e.target.result;  
    //           };
    //           reader.readAsDataURL(fileInput.files[0]);

    //           // angular.element(document.querySelector('[ng-app]')).scope().$apply(function($scope) {
    //           //   $scope.UploadFileIMG(input.files[0]);
    //           // });

    //         } 
    //         else {
    //           imgElement.src = '';
    //         }
    //         $scope.UploadFileIMG(fileInput.files[0]);
    //       })
    //     })
    //   }
    
});
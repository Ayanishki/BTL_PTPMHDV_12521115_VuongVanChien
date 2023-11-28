var app = angular.module('AppBanSach', []);
app.controller("HomeCtrl", function ($scope, $http) {
	$scope.listItem;	
    $scope.GetHoaDon= function () {
        $http({
            method: 'POST',
            data: { page: 1, pageSize: 10},
            url: current_url + '/api/hoadon/search',
        }).then(function (response) {  
            debugger;
            $scope.listItem = response.data.data;  
        });
    };   
	$scope.GetHoaDon();
});
// menu con bán hàng
var getMenu1 = document.querySelector('.menu-1');
var getMenu2 = document.querySelector('.menu-2');
// console.log(getMenu1)
var getBtnDown = document.querySelector('.down');
var getBtnUp = document.querySelector('.up');
getBtnDown.addEventListener('click', function(){
    getMenu1.style.display = 'block'
    getMenu2.style.display = 'block'
    getBtnDown.style.display = 'none'
    getBtnUp.style.display = 'inline-block'
})
getBtnUp.addEventListener('click', function(){
    getMenu1.style.display = 'none'
    getMenu2.style.display = 'none'
    getBtnDown.style.display = 'inline-block'
    getBtnUp.style.display = 'none'
})


// menu con nhập hàng
var getMenu3 = document.querySelector('.menu-3');
var getMenu4 = document.querySelector('.menu-4');
var getMenu5 = document.querySelector('.menu-5');
var getBtnDown1 = document.querySelector('.btn-down');
var getBtnUp1 = document.querySelector('.btn-up');
getBtnDown1.addEventListener('click', function(){
    getMenu3.style.display = 'block'
    getMenu4.style.display = 'block'
    getMenu5.style.display = 'block'
    getBtnDown1.style.display = 'none'
    getBtnUp1.style.display = 'inline-block'
})
getBtnUp1.addEventListener('click', function(){
    getMenu3.style.display = 'none'
    getMenu4.style.display = 'none'
    getMenu5.style.display = 'none'
    getBtnDown1.style.display = 'inline-block'
    getBtnUp1.style.display = 'none'
})

//  menu con phần danh mục
var getMenu6 = document.querySelector('.menu-6');
var getMenu7 = document.querySelector('.menu-7');
var getMenu8 = document.querySelector('.menu-8');
var getMenu9 = document.querySelector('.menu-9');
var getMenu10 = document.querySelector('.menu-10');

var getBtnDown2 = document.querySelector('.btn-down-1');
var getBtnUp2 = document.querySelector('.btn-up-1');
getBtnDown2.addEventListener('click', function(){
    getMenu6.style.display = 'block'
    getMenu7.style.display = 'block'
    getMenu8.style.display = 'block'
    getMenu9.style.display = 'block'
    getMenu10.style.display = 'block'
    getBtnDown2.style.display = 'none'
    getBtnUp2.style.display = 'inline-block'
})
getBtnUp2.addEventListener('click', function(){
    getMenu6.style.display = 'none'
    getMenu7.style.display = 'none'
    getMenu8.style.display = 'none'
    getMenu9.style.display = 'none'
    getMenu10.style.display = 'none'
    getBtnDown2.style.display = 'inline-block'
    getBtnUp2.style.display = 'none'
})
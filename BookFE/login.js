//KHỞI TẠO ĐỐI TƯỢNG VALIDATOR  
function Validator(options){
    // hàm validation  sử lý nút ĐĂNG NHẬP
    //TẤT CẢ HÀM VALIDATOR ĐỀU ĐƯỢC ĐƯA QUA HÀM validator này
    function validator(inputElement, rule){
        //LẤY VALUE NGƯỜI DÙNG NHẬP VÀO  VALUE: inputElement.value, lấy ra test = rule.test
        var errorMessage = rule.test(inputElement.value);
        var errorElement = inputElement.parentElement.querySelector('.form-message');    
        if (errorMessage) {
            errorElement.innerText = errorMessage;
            inputElement.parentElement.classList.add('invalid')
        }
        else {
            errorElement.innerText =''
        }
        console.log(inputElement.value.length)
        // LẤY RA CÁC THẺ CHA TƯƠNG ỨNG VÀ LẤY THG THẺ SPAN CHỨ NỘI DUNG LỖI
        // console.log(inputElement.parentElement.querySelector('.form-message'))
    }

    var formElement = document.querySelector(options.form)
    if (formElement){
        //Lấy ra từng rules trong mảng rules
        options.rules.forEach(function (rule){
            var inputElement = formElement.querySelector(rule.selector);
            var errorElement = inputElement.parentElement.querySelector('.form-message');

            if (inputElement) {
                inputElement.onblur = function () {
                    validator(inputElement, rule);
                }
                //XỬ LÝ KHI NG DÙNG NHẬP THÌ XÓA DÒNG LỖI ĐI
                inputElement.oninput = function(){
                    errorElement.innerText ='';
                    inputElement.parentElement.classList.remove('invalid')
                }
            }          
        })
    }
    // console.log(options.rules)
}
// Khi có lỗi trả ra message lỗi - khi 0 lỗi thì 0 trả ra gì cả
Validator.username = function (selector){
    return {
        selector: selector,
        test: function (value) {
            if (value.length > 20){
                return value= "Tên đăng nhập nhập dưới 20 kí tự"        
            }            
            else if (value.length == 0){
                return value= "Vui lòng nhập trường này"   
            }else{
                return undefined
            }                    
        }      
    }
}
Validator.password = function (selector){
    return {
        selector: selector,
        test: function (value) {
            if (value.length > 20){
                return value= "Mật khẩu phải dưới 20 kí tự"        
            }            
            else if (value.length == 0){
                return value= "Vui lòng nhập trường này"   
            }else{
                return undefined
            }                    
        }      
    }
}
var form = document.getElementById("form-2");
form.addEventListener("submit", function(event) {
  // Ngăn chặn hành động mặc định của form
  event.preventDefault();
  
    window.location.href = "./admin.html";
});

// document.getElementById("form-1").submit();


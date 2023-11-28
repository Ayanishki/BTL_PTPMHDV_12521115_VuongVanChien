let shop = document.getElementById("shop");

let shopItemsData = [
    {
        id: "fsfwsfewfewsrf",
        name: "Overlord",
        price: 111000,
        oldprice: 120000,
        desc: "còn hàng",
        img: "https://cdn0.fahasa.com/media/catalog/product//z/3/z3853755123856_ef10ce3e573421f423e49a9ee9b6b499_1.jpg"
    },
    {
        id: "fsfrfesf",
        name: "Doremon",
        price: 125000,
        oldprice: 150000,
        desc: "còn hàng",
        img: "https://cdn0.fahasa.com/media/catalog/product//z/3/z3853755123856_ef10ce3e573421f423e49a9ee9b6b499_1.jpg"
    },
    {
        id: "fsfwmjsrf",
        name: "Sao",
        price: 36000,
        oldprice: 50000,
        desc: "còn hàng",
        img: "https://cdn0.fahasa.com/media/catalog/product//z/3/z3853755123856_ef10ce3e573421f423e49a9ee9b6b499_1.jpg"
    },
    {
        id: "fhtrfewsrf",
        name: "Conan",
        price: 90000,
        oldprice: 100000,
        desc: "còn hàng",
        img: "https://cdn0.fahasa.com/media/catalog/product//z/3/z3853755123856_ef10ce3e573421f423e49a9ee9b6b499_1.jpg"

    }
];

let basket = JSON.parse(localStorage.getItem("data")) || [];
let generateShop = () => {
    return (shop.innerHTML = shopItemsData
        .map((x) => {
            let { id, name, price, desc, img, oldprice } = x;

            let search = basket.find((x)=>x.id ===id) || []

            return `
        <div class="item-product-cart" id="items">
            <div class="checked-product-cart"><input type="checkbox"
                    id="checkbox-product-412755"
                    name="checkbox_product_412755"
                    class="checkbox-add-cart" checked>
            </div>
            <div class="img-product-cart"><a class="product-image"
                    href="https://www.fahasa.com/chao-mung-den-lop-hoc-de-cao-thuc-luc-tap-4-ban-dac-biet-tang-kem-camera-card.html"><img
                        src="${img}"
                        width="120" height="120"
                        alt="Chào Mừng Đến Lớp Học Đề Cao Thực Lực - Tập 4 - Bản Đặc Biệt - Tặng Kèm Camera Card"></a>
            </div>
            <div class="group-product-info">
                <div class="info-product-cart" >
                    <div>
                        <h2 class="product-name-full-text">
                            <a
                                href="https://www.fahasa.com/chao-mung-den-lop-hoc-de-cao-thuc-luc-tap-4-ban-dac-biet-tang-kem-camera-card.html">${name}
                            </a>
                        </h2>
                        <p class="item-msg notice">${desc}</p>
                    </div>
                    <div class="price-original">
                        <div class="cart-price">
                            <div class="cart-fhsItem-price">
                                <div><span class="price">${price}
                                        đ</span></div>
                                <div class="fhsItem-price-old"><span
                                        class="price">${oldprice}
                                        đ</span></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="number-product-cart">
                    <div class="product-view-quantity-box">
                        <div class="product-view-quantity-box-block ">
                            <a class="btn-subtract-qty" onclick="decrement(${id})">
                                <img
                                    style="width: 12px; height: auto;vertical-align: middle;"
                                    src="https://cdn0.fahasa.com/skin//frontend/ma_vanese/fahasa/images/ico_minus2x.png">
                            </a>
                            <input type="text" class="qty-carts" id="${id}" value="${search.item === undefined? 0: search.item}">
                            <a class="btn-add-qty" onclick="increment(${id})">
                                <img style="width: 12px; height: auto;vertical-align: middle;" src="https://cdn0.fahasa.com/skin/frontend/ma_vanese/fahasa/images/ico_plus2x.png">
                            </a>
                        </div>
                    </div>
                    <div class="cart-price-total"><span
                            class="cart-price"><span
                                class="price" >${(search.item === undefined?0:search.item) * price}
                                đ</span></span></div>
                </div>
            </div>
            <div class="div-of-btn-remove-cart"><a
                    onclick="cart.deleteItem('412755', event);"
                    title="Remove Item"
                    class="btn-remove-desktop-cart">
                    <i class="fi fi-bs-trash"
                        style="font-style: 22px;"></i>
                </a>
            </div>
        </div>
        <div class="border-product"></div>
        `
        }).join(""));
};

generateShop();

let increment = (id) => {
    let selectedItem = id;
    let search = basket.find((x) => x.id === selectedItem.id)

    if (search === undefined) {
        basket.push({
            id: selectedItem.id,
            item: 1,
        });
    } else {
        search.item += 1;
    };

    localStorage.setItem("data",JSON.stringify(basket))
    // console.log(basket);
    update(selectedItem.id);
    generateShop();
};


let decrement = (id) => {
    let selectedItem = id;
    let search = basket.find((x) => x.id === selectedItem.id)

    if (search === undefined) return;
    else if (search.item === 0) return;
    else {
        search.item -= 1;
    };

    update(selectedItem.id);

    basket = basket.filter((x) => x.item !== 0);
    // console.log(basket);
    

    localStorage.setItem("data",JSON.stringify(basket))
    generateShop();
};

let update = (id) => {  
    let search = basket.find((x) => x.id === id)
    let count = document.getElementById(id);
    count.value = search.item;
    
    caculation()
};

let caculation = () => {
    let cartIcon = document.getElementById("cartIcon");
    cartIcon.innerHTML = basket.map((x) => x.item).reduce((x, y) => x + y, 0);  
}; 

caculation();

let generateCartItems = () => {
    if (basket.length !== 0) 
    {
        return
    } 
    else {
        ShoppingCart.innerHTML = ``;
        label.innerHTML = `
        <div style="box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.1);padding: 20px;background-color: #fff;flex: 1; border-radius: 8px;">
            <div class="cart-empty body-mh-300" style="justify-content: center;display: flex;align-items: center;">
                <div style="text-align: center">
                    <div class="icon-empty-cart">\
                        <img src="https://cdn0.fahasa.com/skin//frontend/ma_vanese/fahasa/images/checkout_cart/ico_emptycart.svg" class="center">
                    </div>
                    <p style="font-size:14px;margin: 20px 0;">Chưa có sản phẩm trong giỏ hàng của bạn.</p>
                    <a style="color: white;text-transform: uppercase;" href="/flashsale?fhs_campaign=cta_emptycart">
                        <button
                            class="button-shopping" type="button" title="Mua sắm ngay" style="margin:auto">Mua sắm ngay
                        </button>
                    </a>
                </div>
            </div>
        </div>
        `;
    }
}

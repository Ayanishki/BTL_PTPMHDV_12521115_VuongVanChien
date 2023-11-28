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
];
let basket = JSON.parse(localStorage.getItem("data")) || [];
let generateShop = () => {
    return (shop.innerHTML = shopItemsData
        .map((x) => {
            let { id, name, price, desc, img, oldprice } = x;

            let search = basket.find((x)=>x.id ===id) || []

            return `
        

                        <label for="qty">Số lượng:</label>
                        <div class="product-view-quantity-box-block" style="flex-basis:18%">
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
};

let update = (id) => {
    let search = basket.find((x) => x.id === id)
    let count = document.getElementById(id);
    count.value = search.item;
    caculation()
};
# JavaScript 异步编程：从回调到 async/await

> 发表于 2026-06-10 | 分类：前端开发 | 标签：JavaScript · 异步 · ES6

---

## 前言

JavaScript 是一门单线程语言，这意味着它一次只能做一件事。如果某个任务耗时较长（比如网络请求、文件读取），后面的代码就必须等待，导致页面卡顿。为了解决这个问题，JavaScript 引入了异步编程模型。

本文将通过代码实例，带你了解 JavaScript 异步编程的四种主要方式：回调函数、Promise、Generator 和 async/await。

---

## 1. 回调函数（Callback）—— 最原始的方式

回调函数是最早的异步处理方式：把一个函数作为参数传给异步操作，操作完成后调用这个函数。

```javascript
// 读取文件（Node.js 示例）
const fs = require('fs');

fs.readFile('./data.txt', 'utf-8', (err, data) => {
    if (err) {
        console.error('读取失败:', err);
        return;
    }
    console.log('文件内容:', data);
});

console.log('这条日志会先打印');
```

### 回调地狱（Callback Hell）

当多个异步操作需要按顺序执行时，代码会变成层层嵌套的"金字塔"，这就是臭名昭著的回调地狱：

```javascript
// 先读取用户信息，再根据用户ID查询订单，再根据订单ID查询详情
getUser(userId, (err, user) => {
    if (err) return handleError(err);
    getOrders(user.id, (err, orders) => {
        if (err) return handleError(err);
        getOrderDetail(orders[0].id, (err, detail) => {
            if (err) return handleError(err);
            console.log('订单详情:', detail);
        });
    });
});
```

这种代码难以阅读、难以维护、也难以调试。

---

## 2. Promise —— 更优雅的异步方案

ES6 引入了 Promise 对象，它代表一个异步操作的最终完成（或失败）及其结果值。

### Promise 的三种状态

- **pending（进行中）**：初始状态
- **fulfilled（已成功）**：操作成功完成
- **rejected（已失败）**：操作失败

```javascript
// 创建一个 Promise
const fetchData = (url) => {
    return new Promise((resolve, reject) => {
        // 模拟网络请求
        setTimeout(() => {
            if (url) {
                resolve({ status: 200, data: '请求成功' });
            } else {
                reject(new Error('URL不能为空'));
            }
        }, 1000);
    });
};

// 使用 Promise
fetchData('/api/user')
    .then((response) => {
        console.log('成功:', response);
        return response.data;
    })
    .then((data) => {
        console.log('数据:', data);
    })
    .catch((error) => {
        console.error('失败:', error.message);
    })
    .finally(() => {
        console.log('请求结束（无论成功或失败）');
    });
```

### Promise 链式调用解决回调地狱

```javascript
getUser(userId)
    .then(user => getOrders(user.id))
    .then(orders => getOrderDetail(orders[0].id))
    .then(detail => console.log('订单详情:', detail))
    .catch(err => console.error('出错:', err));
```

---

## 3. async/await —— 异步编程的终极方案

ES2017 引入了 async/await，它基于 Promise，但让异步代码看起来像同步代码。

### 基本语法

```javascript
// async 函数总是返回一个 Promise
async function getUserData(userId) {
    // await 等待 Promise 完成，并取出其结果值
    const user = await getUser(userId);
    const orders = await getOrders(user.id);
    const detail = await getOrderDetail(orders[0].id);
    return detail;
}

// 调用 async 函数
getUserData(1)
    .then(detail => console.log('订单详情:', detail))
    .catch(err => console.error('出错:', err));
```

### 错误处理

```javascript
async function fetchWithErrorHandling() {
    try {
        const response = await fetch('/api/data');
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('请求失败:', error.message);
        // 可以返回默认值或重新抛出
        return null;
    }
}
```

### 并发请求

```javascript
// ❌ 顺序执行（慢）
const user = await fetchUser(1);
const posts = await fetchPosts(1);  // 等 user 完成后才开始

// ✅ 并发执行（快）
const [user, posts] = await Promise.all([
    fetchUser(1),
    fetchPosts(1)
]);
```

---

## 4. 事件循环（Event Loop）—— 理解异步的本质

很多人对 `setTimeout` 的以下行为感到困惑：

```javascript
console.log('1');

setTimeout(() => {
    console.log('2');
}, 0);

console.log('3');

// 输出顺序：1 → 3 → 2
```

这是因为 JavaScript 的事件循环机制：

1. **调用栈（Call Stack）**：执行同步代码
2. **任务队列（Task Queue）**：存放异步回调（setTimeout、事件监听等）
3. **微任务队列（Microtask Queue）**：存放 Promise 回调（.then/.catch）

执行顺序：**同步代码 → 微任务 → 宏任务**

```javascript
console.log('A');

setTimeout(() => console.log('B'), 0);

Promise.resolve().then(() => console.log('C'));

console.log('D');

// 输出顺序：A → D → C → B
```

---

## 5. 四种方案对比总结

| 方案 | 优点 | 缺点 |
|------|------|------|
| **回调函数** | 简单直接，无学习成本 | 回调地狱，错误处理困难 |
| **Promise** | 链式调用，统一错误处理 | 仍然需要 .then() 嵌套 |
| **Generator** | 可以暂停/恢复执行 | 需要配合执行器，使用复杂 |
| **async/await** | 代码像同步，易读易维护 | 需要理解 Promise 基础 |

---

## 总结

- **回调函数**适合简单的单次异步操作
- **Promise**是异步编程的基础，理解它对学习后续内容至关重要
- **async/await**是推荐的现代写法，让异步代码清晰易读
- 理解**事件循环**机制，才能真正掌握 JavaScript 的异步行为

在日常开发中，建议优先使用 **async/await** 编写异步代码，它是目前最清晰、最易于维护的方式。

---

*本文为个人学习笔记，如有疏漏欢迎指正。*

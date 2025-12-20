---
title: "Inception & Cloud-1 Project Wiki"
date: 2025-12-20
---

# Inception (Cloud-1 Phase 1)

## 🏗 Architecture

| Service | Image (Base) | Role | Port (Internal) | Port (Exposed) |
| :--- | :--- | :--- | :--- | :--- |
| **NGINX** | Alpine latest | Reverse Proxy, TLS Termination | 443 | 443 |
| **WordPress** | Alpine latest | CMS (PHP 8.3 + PHP-FPM) | 9000 | - |
| **MariaDB** | Alpine latest | Database | 3306 | - |
| **Redis** | Alpine latest | Object Cache for WordPress | 6379 | - |
| **FTP** | Alpine latest | File Transfer (vsftpd) | 21 | 21, 21100-21110 |
| **Adminer** | Alpine latest | Database Management Tool | 8080 | - |
| **Static Site**| Alpine latest | Profile Site (Golang Server) | 1313 | - |

## 🚀 Prerequisites

* Docker & Docker Compose
* Make
* **Hosts File Configuration:**
    * `login.42.fr` がローカルホストを指すように設定してください。
    * **Windows (WSL2):** `C:\Windows\System32\drivers\etc\hosts`
    * **Linux/Mac:** `/etc/hosts`
    ```text
    127.0.0.1 login.42.fr
    ```

## 🛠 Installation & Usage

### 環境の立ち上げ (Build & Start)

データディレクトリを作成し、コンテナをビルドして起動します。

```bash
make
# または
make up
```

### 停止 (Stop)

コンテナを停止・削除しますが、データベースとWordPressのデータは保持されます。

```bash
make down
```

### 完全リセット (Full Clean & Rebuild)

コンテナ、ネットワークに加え、永続化データ（DB, 投稿データ等）を全て物理削除

```bash
make fclean
```

初期状態から再構築します

```bash
make re
```

## ✅ Verification & Testing (Mandatory + Bonus)

### 1. Web Access (HTTPS)

ブラウザで `https://login.42.fr` にアクセス。

- 期待値: `WordPress` のトップページが表示されること（自己署名証明書の警告は正常）。
- NGINX: HTTP (80) ではなく HTTPS (443) のみが提供されていること。

### 2. Redis Cache

- URL: `https://login.42.fr/wp-admin/` (User/Pass は `.env` 参照)
-  確認: 左メニュー "Settings" -> "Redis" を開き、Status が "Connected" であること。

### 3. FTP & Persistence (Media Import)

FTP で画像をアップロードし、WordPress にインポートすることで、ボリューム共有と永続化を確認します。

1. FTP アップロード (ホスト側ターミナル):

```bash
# テスト画像を用意
ftp -p localhost 21
# User/Pass は .env 参照
ftp> cd wp-content/uploads
ftp> put test_image.jpg
ftp> bye
```
2. WordPress へのインポート:

```bash
docker compose exec wordpress wp media import /var/www/wordpress/wp-content/uploads/test_image.jpg --allow-root
```

3. 確認: WordPress 管理画面の「メディア」に画像が追加されていること。
4. 永続化テスト: `make down` -> `make up` 後も画像や記事が消えていないこと。

### 4. Adminer (DB Management)

- URL: `https://login.42.fr/adminer`
- Login:
  - System: `MySQL`
  - Server: `mariadb` (重要: `localhost` ではない)
  - User/Pass: `.env` の一般ユーザー情報
- 確認: ログインでき、テーブル一覧が表示されること。

### 5. Static Website (Golang)

- URL: `https://login.42.fr/static/`
- 確認: カスタムデザインされた静的サイトが表示されること。
- 分離テスト: `docker compose stop static_website` 実行後、WP は見れるが Static サイトだけ 502 エラーになること。
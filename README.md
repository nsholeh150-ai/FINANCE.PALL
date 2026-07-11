# Dashboard Keuangan Anak Muda

Dashboard interaktif untuk pelajar, mahasiswa, dan first jobber. Angka pemasukan, pengeluaran, dana darurat, investasi, target menabung, dan simulasi financial freedom bisa diubah langsung di browser. Dashboard juga sudah terhubung ke Supabase agar rencana finance dapat disimpan dan dimuat ulang memakai nama akses pengguna.

## Isi paket

- `index.html` - website utama siap GitHub Pages.
- `.nojekyll` - memastikan GitHub Pages menyajikan file statis tanpa proses Jekyll.
- `supabase/schema.sql` - schema database untuk tabel `finance_budget_plans`.

## Fitur utama

- Dashboard budget dengan pie chart, diagram batang, dan proyeksi dana darurat.
- Kode akses database dari nama pengguna.
- Menu Menabung untuk barang atau trip dengan target harian, estimasi hari, dan saran yang bisa diklik untuk melihat rumusnya.
- Menu Masa Depan untuk menghitung financial freedom memakai 4% rule / rule of 25, lengkap dengan detail rumus dan cara membaca hasil.

## Cara upload ke GitHub Pages

1. Buat repository GitHub baru atau buka repository yang sudah ada.
2. Upload seluruh isi folder ini ke root repository. Alternatif lain: upload ke folder `docs/`.
3. Buka `Settings > Pages`.
4. Pilih `Deploy from a branch`.
5. Pilih branch `main` dan folder `/root` jika file ada di root, atau `/docs` jika memakai folder docs.
6. Simpan, lalu tunggu URL GitHub Pages aktif.

## Database Supabase

Project Supabase yang dipakai di dashboard saat ini sudah diarahkan ke URL publik yang tertanam di `index.html`. Data disimpan memakai `save_code` yang dibuat dari nama akses. Jika ingin memakai project Supabase lain:

1. Jalankan isi `supabase/schema.sql` di SQL Editor Supabase.
2. Ganti nilai `SUPABASE_URL` dan `SUPABASE_ANON_KEY` di `index.html`.
3. Pastikan tabel `finance_budget_plans` dan RLS policy dari schema sudah aktif.

Catatan: anon key Supabase memang aman untuk frontend jika RLS sudah benar. Jangan pernah menaruh service role key di file ini.

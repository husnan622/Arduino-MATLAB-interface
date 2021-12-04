% Lakukan konfigurasi untuk menyimpan data kita
saveplotlycredentials('AkunSaya', 'abcde12345', ...
	{'123456789a', '123456789b' , '123456789c'})
% load hasil konfigurasi
data_saya = loadplotlycredentials;
% ambil satu token.. bisa dipilih sesuai keinginan
streamTokenSaya = data_saya.stream_ids{1};
% seting awal untuk data
data{1}.x = []; 
data{1}.y = [];
data{1}.type = 'scatter';
data{1}.stream.token = streamTokenSaya;
data{1}.stream.maxpoints = 30;
args.filename = 'STREAM_PERTAMA_SAYA'; 
args.fileopt = 'overwrite';
% lakukan koneksi dan amati respon
respon = plotly(data,args);
% Kirim data ke Command Window dan kunjungi alamat ini
alamatURL = respon.url
% mulai lakukan inisialisasi data streaming
ps = plotlystream(streamTokenSaya);
% mulai streaming
ps.open(); 
% misalkan kita kirim data random sebanyak 1000 data
for i = 1:1000
    mydata.x = i; 
    mydata.y = rand; 
    ps.write(mydata);
    pause(0.05); 
end
% setelah selesai, tutup streaming
ps.close();


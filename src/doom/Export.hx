package doom;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import sys.io.File;

import gameboy.GBSprite;

/**
 * ...
 * @author Kaelan
 */
class Export 
{
	static inline var PICHEADERSIZE:Int = 8;
	
	public static function writePicture(_pic:Picture, _path:String)
	{
		var picturebytes:BytesOutput = new BytesOutput();
		
		picturebytes.writeInt16(_pic.width);
		picturebytes.writeInt16(_pic.height);
		picturebytes.writeInt16(_pic.xoffset);
		picturebytes.writeInt16(_pic.yoffset);
		
		var offset = (4 * _pic.width) + PICHEADERSIZE;
		
		var columns:Array<Array<Post>> = [];
		
		for (post in _pic.posts)
		{
			if (columns[post.xoffset] == null) columns[post.xoffset] = new Array();
			columns[post.xoffset].push(post);
		}
		
		var postbytes:BytesOutput = new BytesOutput();
		
		for (column in columns)
		{
			var subbytes:BytesOutput = new BytesOutput();
			
			for (post in column)
			{
				subbytes.writeByte(post.yoffset);
				subbytes.writeByte(post.length);
				subbytes.writeByte(0xFB);
				
				for (pixel in post.pixels) subbytes.writeByte(pixel);
				
				subbytes.writeByte(0xFB);
			}
			
			subbytes.writeByte(0xFF);
			
			picturebytes.writeInt32(offset);
			offset += subbytes.length;
			
			var result = subbytes.getBytes();
			postbytes.writeFullBytes(result, 0, result.length);
		}
		
		var imagedata:Bytes = postbytes.getBytes();
		picturebytes.writeFullBytes(imagedata, 0, imagedata.length);
		picturebytes.writeByte(0x00);
		
		File.saveBytes(_path, picturebytes.getBytes());
	}
	
	public static function pixelsToPosts(_pixels:Array<Int>, _xoffset:Int, _zeroIsAlpha:Bool = true):Array<Post>
	{
		var posts:Array<Post> = [];
		
		var inPixels:Bool = false;
		var offset:Int = 0;
		var alphoffset:Int = 0;
		var data:Array<Int> = [];
		
		if (!_zeroIsAlpha)
		{
			for (i in 0..._pixels.length)
			{
				if (_pixels[i] == 0) _pixels[i] = 5;
			}
		}
		
		for (pixel in _pixels)
		{
			if (pixel != 0)
			{
				if (!inPixels) alphoffset = offset;
				inPixels = true;
				data.push(pixel);
			}
			else if (pixel == 0 && !inPixels)
			{
			
			}
			else if (pixel == 0 && inPixels)
			{
				var post:Post =
				{
					xoffset : _xoffset,
					yoffset : alphoffset,
					length : data.length,
					pixels : data.copy(),
				}
				
				alphoffset += data.length;
				posts.push(post);
				
				data = new Array();
				
				inPixels = false;
				
			}
			
			++offset;
		}
		
		if (alphoffset != 0 && data.length == 0)
		{
			
		}
		else
		{
			var post:Post =
			{
				xoffset : _xoffset,
				yoffset : alphoffset,
				length : data.length,
				pixels : data.copy(),
			}
			
			posts.push(post);
		}
		
		return posts;
	}
	
	public static function spritesToPicture(_data:Array<Int>, _width:Int, _height:Int, _zeroIsAlpha:Bool = true)
	{
		var posts:Array<Post> = [];
		var sprites:Array<GBSprite> = GBSprite.spritesFromData(_data);
		
		if (!_zeroIsAlpha) trace(sprites.length);
		
		var index:Int = _height * -1;
		
		sprites = sprites.slice(0, _width * _height);
		
		var spindex:Int = 0;
		
		for (col in 0...(8 * _width))
		{
			if (col % 8 == 0) index += _height;
			
			var column:Array<Int> = [];
			
			for (row in 0..._width)
			{
				var sprite = sprites[index + row];
				
				if (sprite == null) 
				{
					sprite = GBSprite.emptySprite;
				}
				
				var strip = sprite.getVerticalStrip(col % 8);
				for (pixel in strip) column.push(pixel);
			}
			
			var items:Array<Post> = Export.pixelsToPosts(column, col, _zeroIsAlpha);
			for (item in items) posts.push(item);
		}
		
		var picture:Picture =
		{
			width : 8 * _width,
			height : 8 * _height,
			xoffset : 4 * _width,
			yoffset : 8 * _height,
			posts : posts
		}
		
		return picture;
	}
	
	public static function spritesToPictureArray(_data:Array<Int>):Array<Picture>
	{
		var pictures:Array<Picture> = [];
		var sprites:Array<GBSprite> = GBSprite.spritesFromData(_data, true);
		
		for (sprite in sprites)
		{
			var posts:Array<Post> = [];
			
			for (col in 0...8)
			{
				var column:Array<Int> = [];
			
				for (row in 0...8)
				{
					var strip = sprite.getVerticalStrip(col % 8);
					for (pixel in strip) column.push(pixel);
				}
				
				var items:Array<Post> = Export.pixelsToPosts(column, col);
				for (item in items) posts.push(item);
			}
		
			var picture:Picture =
			{
				width : 8,
				height : 8,
				xoffset : 4,
				yoffset : 8,
				posts : posts
			}
			
			pictures.push(picture);
		}
		
		return pictures;
	}
}
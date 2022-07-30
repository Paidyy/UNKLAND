import haxe.Exception;
import flixel.system.FlxAssets.FlxShader;

@:deprecated("DOESNT WORK FOR NOW")
class LightShader extends FlxShader {
    public static var instance:LightShader = null;

    public function new() {
      super();

      if (instance != null)
			  throw new Exception("LightShader should have only 1 instance!");
      
		  instance = this;

		  setBrightness(1);
    }

    public static function update() {
		  setBrightness(Util.curBrightnessWorldTime());
    }

    public static function setBrightness(value:Float) {
		  Reflect.setProperty(Reflect.field(instance, "brightness"), "value", [value]);
    }

    @:glFragmentSource('
		#pragma header

        uniform float brightness = 0.2;

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4(color.r * brightness, color.g * brightness, color.b * brightness, color.a);
        }
    ')
}